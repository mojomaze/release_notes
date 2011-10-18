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

# == Schema Information
#
# Table name: mantis_project_version_table
#
#  id          :integer(4)      not null, primary key
#  project_id  :integer(4)      default(0), not null
#  version     :string(64)      default(""), not null
#  description :text            default(""), not null
#  released    :integer(1)      default(1), not null
#  obsolete    :integer(1)      default(0), not null
#  date_order  :integer(4)      default(1), not null
#

