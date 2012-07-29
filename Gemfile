source 'http://rubygems.org'

gem 'rails',          '~> 2.3'
gem 'ffi',            '1.0.11' # just fixed because I could not build 1.1.1 on 10.8

group :production do
  gem 'mysql2'
end

group :devlopment, :test do
  gem 'rspec-rails',    '1.3.3'
  gem 'sqlite3-ruby',   '1.2.5',   :require => 'sqlite3'
end

group :tools do
  gem 'autotest',         :require => nil
  gem 'autotest-rails',   :require => nil
  gem 'autotest-fsevent', :require => nil
  gem 'capistrano',       :require => nil
end
