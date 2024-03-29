# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a3082ac8bc512a6ef198287dc97ff258'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  before_filter :set_locale_from_request
  
private

  def set_locale_from_request
    requested_locale = request.preferred_language_from(%w{en-US de-DE}) || 'en-US'
    I18n.locale = requested_locale
    logger.debug "Using locale #{requested_locale} for this request"
  end
end
