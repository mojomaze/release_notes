# Authlogic helpers

# below user_session fails 

def current_user(stubs = {})
  @current_user ||= mock_model(User, stubs)
end

# def user_session(stubs = {}, user_stubs = {})
#   @current_user ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
# end
#
# def login(session_stubs = {}, user_stubs = {})
#   UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
# end
#
# def logout
#   @user_session = nil
# end

def login
  user = current_user(:prefs => {:basecamp_url => basecamp_url, :basecamp_authkey => basecamp_authkey})
  controller.stub(:current_user).and_return(user)
end

def logout
  controller.stub(:current_user).and_return(nil)
end