# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  include SessionsHelper
  
  def find_or_create_security(ticker)
    security = Security.find_by_ticker(ticker)
    
    if not security 
      security = Security.create(:ticker => ticker)
    end 
    return security
  end
  
end
