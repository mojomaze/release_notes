class MantisProjectVersionTable < ActiveRecord::Base
  establish_connection "mantis"
  set_table_name "mantis_project_version_table"
  
  belongs_to :mantis_project_table
  
  def self.unreleased(project_id = nil)
    order('date_order').where('project_id = ? AND released = ? AND obsolete = ?', project_id, 0, 0)
  end
  
  def release_version(undo = nil)
    code = undo ? 0 : 1
    self.released = code
    self.date_order = Time.now.to_i
    if self.save
      return true
    end
    return false
  end
  
end
