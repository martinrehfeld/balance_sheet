#require 'rake/tasklib'
require 'thread'
require 'webrick'

class JavaScriptTest
  
  class Browser
    def supported?; true; end
    def setup ; end
    def open(url) ; end
    def teardown ; end
  
    def host
      require 'rbconfig'
      Config::CONFIG['host']
    end
    
    def macos?
      host.include?('darwin')
    end
    
    def windows?
      host.include?('mswin')
    end
    
    def linux?
      host.include?('linux')
    end
    
    def applescript(script)
      raise "Can't run AppleScript on #{host}" unless macos?
      system "osascript -e '#{script}' 2>&1 >/dev/null"
    end
  end
  
  class FirefoxBrowser < Browser
    def initialize(path='c:\Program Files\Mozilla Firefox\firefox.exe')
      @path = path
    end
  
    def visit(url)
      system("open -a Firefox '#{url}'") if macos?
      system("#{@path} #{url}") if windows? 
      system("firefox #{url}") if linux?
    end
  
    def to_s
      "Firefox"
    end
  end
  
  class SafariBrowser < Browser
    def supported?
      macos?
    end
    
    def setup
      applescript('tell application "Safari" to make new document')
    end
    
    def visit(url)
      applescript('tell application "Safari" to set URL of front document to "' + url + '"')
    end
  
    def teardown
      #applescript('tell application "Safari" to close front document')
    end
  
    def to_s
      "Safari"
    end
  end
  
  class IEBrowser < Browser
    def setup
      require 'win32ole' if windows?
    end

    def supported?
      windows?
    end

    def visit(url)
      if windows?
        ie = WIN32OLE.new('InternetExplorer.Application')
        ie.visible = true
        ie.Navigate(url)
        while ie.ReadyState != 4 do
          sleep(1)
        end
      end
    end

    def to_s
      "Internet Explorer"
    end
  end
  
  class KonquerorBrowser < Browser
    def supported?
      linux?
    end
    
    def visit(url)
      system("kfmclient openURL #{url}")
    end
    
    def to_s
      "Konqueror"
    end
  end
  
  class HtmlUnitBrowser < Browser
    def supported?
      true
    end
    
    def visit(url)
      system("java -jar '#{File.join(File.dirname(__FILE__),'HtmlUnitTestrunner.jar')}' '#{url}'")
    end
    
    def to_s
      "HTMLUnit"
    end
  end
  
  # shut up, webrick :-)
  class ::WEBrick::HTTPServer
    def access_log(config, req, res)
      # nop
    end
  end
  class ::WEBrick::BasicLog
    def log(level, data)
      # nop
    end
  end
  
  class NonCachingFileHandler < WEBrick::HTTPServlet::FileHandler
    def do_GET(req, res)
      super
      res['etag'] = nil
      res['last-modified'] = Time.now + 1000
      res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0"'
      res['Pragma'] = 'no-cache'
      res['Expires'] = Time.now - 1000
    end
  end
  
  class Runner
  
    def initialize(name=:test)
      @name = name
      @tests = []
      @browsers = []
      @result = true
  
      @queue = Queue.new
  
      result = []
  
      @server = WEBrick::HTTPServer.new(:Port => 4711) # TODO: make port configurable
      @server.mount_proc("/results") do |req, res|
        @queue.push("Assertions:#{req.query['assertions']}, Failures:#{req.query['failures']}, Errors:#{req.query['errors']}")
        res.body = "OK"
      end
      yield self if block_given?
      
      define
    end
    
    def successful?
      @result
    end
  
    def define
      trap("INT") { @server.shutdown }
      t = Thread.new { @server.start }
      
      tests_ok = []
      # run all combinations of browsers and tests
      @browsers.each do |browser|
        if browser.supported?
          browser.setup
          @tests.each do |test|
            browser.visit("http://localhost:4711#{test}?resultsURL=http://localhost:4711/results&t=" + ("%.6f" % Time.now.to_f))
            result = @queue.pop
            puts "#{test} on #{browser}: #{result}"
            @result = false unless result =~ /Failures:0, Errors:0/
            
          end
          browser.teardown
        else
          puts "Skipping #{browser}, not supported on this OS"
        end
        browser.teardown
      end
      
      @server.shutdown
      t.join
    end
  
    def mount(path, dir=nil)
      dir ||= (Dir.pwd + path)
  
      @server.mount(path, NonCachingFileHandler, dir)
    end
  
    # test should be specified as a url
    def run(test)
      url = "/test/javascript/#{test}_test.html"
      unless File.exists?(RAILS_ROOT+url)
        raise "Missing test file #{url} for #{test}"
      end
      @tests << url
    end
  
    def browser(browser)
      browser =
        case(browser)
          when :firefox
            FirefoxBrowser.new
          when :safari
            SafariBrowser.new
          when :ie
            IEBrowser.new
          when :konqueror
            KonquerorBrowser.new
          when :htmlunit
            HtmlUnitBrowser.new
          else
            browser
        end
  
      @browsers<<browser
    end
  end

end