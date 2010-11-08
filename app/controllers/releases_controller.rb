class ReleasesController < ApplicationController
  SGI_COMPANY_ID = 247860
  
  # GET /releases
  # GET /releases.xml
  def index
    
    params[:page] ||= 1
        
    @releases = Release.search(params[:search], params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.xml
  def show
    @release = Release.find(params[:id])
    
    # send to archive page if archived
    redirect_to(:controller => 'archives', :action => 'show', :id => @release.id) and return if @release.archived
    
    # mantis info
    # get unreleased versions from mantis
    @version_list = MantisProjectVersionTable.unreleased(@release.mantis_project_id).all.collect{|v| [ v.version, v.id ] }
    # populate release fixes from mantis
    if @release.mantis_project_version_id
      @issues = Issue.fixed(@release.mantis_project_id, @release.mantis_project_version_name)
    end
    
    #basecamp info
    begin
      basecamp_connect
      @categories = Basecamp::Category.post_categories(@release.basecamp_project_id).collect{|c| [ c.name, c.id ] }
      @basecamp = Basecamp.new
      @sgi = @basecamp.people(SGI_COMPANY_ID, @release.basecamp_project_id)
      @people = @basecamp.people(@release.basecamp_company_id, @release.basecamp_project_id) if @release.basecamp_company_id != SGI_COMPANY_ID
    rescue Exception => err
      redirect_to(user_preferences_edit_path, :notice => "Could not connect to basecamp: #{err}") and return
    end
    
    @version_released = @release.released?
    @version_release_date = @release.release_date.strftime("%Y-%m-%d") if @version_released && @release.release_date
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @release }
    end
  end

  # GET /releases/new
  # GET /releases/new.xml
  def new
    @release = Release.new
    # protected controller method
    begin
      build_project_lists
    rescue Exception => err
      redirect_to(user_preferences_edit_path, :notice => "Could not connect to basecamp: #{err}") and return
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
    # protected controller method
    begin
      build_project_lists
    rescue Exception => err
      redirect_to(user_preferences_edit_path, :notice => "Could not connect to basecamp: #{err}") and return
    end
  end

  # POST /releases
  # POST /releases.xml
  def create
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to(@release, :notice => 'Release was successfully created.') }
        format.xml  { render :xml => @release, :status => :created, :location => @release }
      else
        # protected controller method
        begin
          build_project_lists
        rescue Exception => err
          redirect_to(user_preferences_edit_path, :notice => "Could not connect to basecamp: #{err}") and return
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /releases/1
  # PUT /releases/1.xml
  def update
    @release = Release.find(params[:id])
    # add the user's id
    params[:release][:user_id] = @current_user.id
  
    if @release.update_attributes(params[:release])
      # handle release posting if necessary
      if params[:post_release]
        @issues = Issue.fixed(@release.mantis_project_id, @release.mantis_project_version_name)
        @notify = params[:notify]
        body = render_to_string(:partial =>'releases/release', :object => @release, :locals => { :format_xml => true } )
        @release.publish_release(body)
      end
    end
    
    respond_to do |format|
      if !@release.invalid?
        if params[:post_release]
          notice = 'Release posted successfully.'
        else
          notice = 'Release was successfully updated.'
        end
        format.html { redirect_to(@release, :notice => notice) }
      else
        if params[:post_release] || params[:set_version]
          format.html { redirect_to(@release, :error => "Errors!!!") }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end

  # DELETE /releases/1
  # DELETE /releases/1.xml
  def destroy
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to(releases_url) }
      format.xml  { head :ok }
    end
  end
  
  def rollback
    result = false
    @release = Release.find(params[:id])
    # send parameter true to rollback release
    version = MantisProjectVersionTable.find_by_id(@release.mantis_project_version_id)
    if version && version.release_version(true)
      if ProjectConnect.delete_message(current_user.prefs.basecamp_authkey, @release.basecamp_message_id)
        @release.basecamp_message_id = nil
        @release.save
        result = true
      end
    end
    respond_to do |format|
      if result
        format.html { redirect_to(@release, :notice => "Release rolled back and basecamp message deleted") }
      else
        format.html { redirect_to(@release, :notice => "Error: Could not roll back release") }
      end
    end 
  end
  
  # GET /archives/1/unarchive
  def archive
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attribute('archived', true)
        format.html { redirect_to(:controller => 'archives', :action => 'show', :id => @release.id,
           :notice => 'Release was successfully archived.') }
      else
        format.html { redirect_to(@release, :notice => 'Error archiving release.') }
      end
    end
  end
  
  def list_action
    case params[:action_type]
    when 'archive'
      params[:action_id].each do |id|
          Release.update_all(['archived = ?', true], ['id = ?', id])
      end
    when 'delete'
      params[:action_id].each do |id|
        @release = Release.find(id)
        @release.destroy
      end
    end
    
    respond_to do |format|
      format.html { redirect_to(releases_url) }
      format.xml  { head :ok }
    end 
  end
  
  protected
  # get basecamp and mantis project names
  def build_project_lists
    # call the application controller connect funtion
    basecamp_connect
    projects = [ ]
    all_projects = Basecamp::Project.find(:all)
    all_projects.each do |project|
      projects << [project.name, project.id] if project.status == 'active'
    end
    @project_list = projects.sort_by{|name, value| name}
    
    @mantis_list = MantisProjectTable.order("name").all.collect{|p| [ p.name, p.id ] }
  end
end