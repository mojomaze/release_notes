class ArchivesController < ApplicationController
  SGI_COMPANY_ID = 247860
  
  # GET /releases
  # GET /releases.xml
  def index
    params[:page] ||= 1
    
    @releases = Release.search_archive(params[:search], params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.xml
  def show
    @release = Release.find(params[:id])
    
    # send to release page if not archived
    redirect_to(:controller => 'releases', :action => 'show', :id => @release.id) and return if !@release.archived
    
    # populate release fixes from mantis
    if @release.mantis_project_version_id
      @issues = Issue.fixed(@release.mantis_project_id, @release.mantis_project_version_name)
    end
    @version_released = @release.released?
    @version_release_date = @release.release_date.strftime("%Y-%m-%d") if @version_released && @release.release_date
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @release }
    end
  end
  
  # GET /archives/1/unarchive
  def unarchive
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attribute('archived', false)
        format.html { redirect_to(@release, :notice => 'Release was successfully activated.') }
      else
        format.html { redirect_to(:controller => 'releases', :action => 'show', :id => @release.id,
           :notice => 'Error activating release.') }
      end
    end
  end
  
  def list_action
    case params[:action_type]
    when 'unarchive'
      params[:action_id].each do |id|
          Release.update_all(['archived = ?', false], ['id = ?', id])
      end
    when 'delete'
      params[:action_id].each do |id|
        @release = Release.find(id)
        @release.destroy
      end
    end
    
    respond_to do |format|
      format.html { redirect_to(archives_url) }
      format.xml  { head :ok }
    end 
  end
end
