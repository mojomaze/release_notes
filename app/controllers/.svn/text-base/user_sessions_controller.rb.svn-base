class UserSessionsController < ApplicationController
  
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    if current_user
      redirect_to releases_url
    end
    @user_session = UserSession.new
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      # test the mantis connection on login
      begin
        project = MantisProjectTable.first
      rescue Mysql::Error => err
        redirect_to(user_preferences_edit_path, :notice => "Could not connect to mantis: #{err}") and return
      end
      
      flash[:notice] = 'Successfully logged in.'
      redirect_to releases_path
    else
      render :action => "new"
    end
    
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy 
      flash[:notice] = "Successfully logged out."
    end
    redirect_to root_url
  end
  
  protected
  def authorize
  end
  
end
