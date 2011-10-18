class Release < ActiveRecord::Base
  belongs_to :user
  
  validates :basecamp_project_id, :mantis_project_id, :presence => true
  
  before_save :set_project_names
  
  # sets the default pagination limit
  def self.per_page
    50
  end
  
  def self.search(query, page)
    if query
      search = "%#{query}%"
      return where("(mantis_project_name LIKE ? OR basecamp_project_name LIKE ?) AND archived = ?", search, search, false).paginate(:page => page)
   end
   where('archived = ?', false).paginate(:page => page)
  end
  
  def self.search_archive(query, page)
    if query
      search = "%#{query}%"
      return where("(mantis_project_name LIKE ? OR basecamp_project_name LIKE ?) AND archived = ?", search, search, true).paginate(:page => page)
   end
   where('archived = ?', true).paginate(:page => page)
  end
  
  def released?
    if self.mantis_project_version_id
      version = MantisProjectVersionTable.find_by_id(mantis_project_version_id)
      return true if version && version.released == 1
    end
    return false
  end
  
  def release_date
    if self.mantis_project_version_id
      version = MantisProjectVersionTable.find_by_id(mantis_project_version_id)
      if version && version.released == 1
        return version.date_order if version.date_order
      end
    end
    return nil
  end
  
  def publish_release(body = nil)
    if self.mantis_project_version_id
      begin 
        MantisProjectVersionTable.transaction do
          version = MantisProjectVersionTable.find_by_id(self.mantis_project_version_id)
          if version.release_version
            conn = basecamp_connect
            message = Basecamp::Message.create(conn, self.basecamp_project_id, body)
            if message
              self.basecamp_message_id = message.to_i
              self.save
            else 
              errors[:base] << "Could not create basecamp message"
              raise ActiveRecord::Rollback
            end
          else
            errors[:base] << "Could not release version in mantis"
            raise ActiveRecord::Rollback
          end
        end
      end
    else
     errors[:base] << "Please set a mantis project version"
    end
  end
  
  protected
  def set_project_names
    if basecamp_project_id_changed?
      conn = basecamp_connect
      project = Basecamp::Project.find(conn, basecamp_project_id)
      if project
        self.basecamp_project_name = project.name 
        self.basecamp_company_id = project.company.id
      end
    end
    
    if mantis_project_id_changed?
      project = MantisProjectTable.find_by_id(mantis_project_id)
      self.mantis_project_name = project.name if project
      # clear the selected version since project changed
      reset_version
    end
    
    if mantis_project_version_id_changed?
      version = MantisProjectVersionTable.find_by_id(mantis_project_version_id)
      self.mantis_project_version_name = version.version if version
    end
  end
  
  def reset_version
    self.mantis_project_version_id = nil
    self.mantis_project_version_name = nil
  end
  
  private
    def basecamp_connect
      connection = Basecamp::Connect.new(current_user.prefs[:basecamp_url], current_user.prefs[:basecamp_authkey])
    end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
  
end

# == Schema Information
#
# Table name: releases
#
#  id                           :integer         not null, primary key
#  basecamp_project_id          :integer
#  mantis_project_id            :integer
#  created_at                   :datetime
#  updated_at                   :datetime
#  basecamp_project_name        :string(255)
#  mantis_project_name          :string(255)
#  mantis_project_version_id    :integer
#  mantis_project_version_name  :string(255)
#  basecamp_company_id          :integer
#  basecamp_message_category_id :integer
#  basecamp_message_id          :integer
#  archived                     :boolean         default(FALSE)
#  user_id                      :integer
#

