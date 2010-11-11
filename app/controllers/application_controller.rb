class ApplicationController < ActionController::Base
  before_filter :authorize
  
  protect_from_forgery
  layout 'application'
  
  helper_method :current_user
  
  def basecamp_connect
    connection = Basecamp::Connect.new(current_user.prefs[:basecamp_url], current_user.prefs[:basecamp_authkey])
  end
  
  protected
    def authorize
      unless current_user
        redirect_to root_url
      end
    end
    
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
end