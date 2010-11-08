class Issue < ActiveRecord::Base
  establish_connection "mantis"
  set_table_name "mantis_bug_table"
  
  belongs_to :mantis_project_table
  
  # mantis status & resolution codes
  RESOLVED = 80
  CLOSED = 90
  FIXED = 20
  
  # release note field id
  RELEASE_NOTE = 4
  
  def self.fixed(project_id = nil, version = nil)
    order('id').where('project_id = ? AND fixed_in_version = ? AND resolution = ? AND (status = ? OR status  = ?)', project_id, version, FIXED, RESOLVED, CLOSED)
  end
  
  def release_notes
    custom = MantisCustomFieldStringTable.where('bug_id = ? AND field_id = ?', self.id, RELEASE_NOTE).first
    custom.value
  end
  
end
