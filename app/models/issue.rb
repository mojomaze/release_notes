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

# == Schema Information
#
# Table name: mantis_bug_table
#
#  id                :integer(4)      not null, primary key
#  project_id        :integer(4)      default(0), not null
#  reporter_id       :integer(4)      default(0), not null
#  handler_id        :integer(4)      default(0), not null
#  duplicate_id      :integer(4)      default(0), not null
#  priority          :integer(2)      default(30), not null
#  severity          :integer(2)      default(50), not null
#  reproducibility   :integer(2)      default(10), not null
#  status            :integer(2)      default(10), not null
#  resolution        :integer(2)      default(10), not null
#  projection        :integer(2)      default(10), not null
#  eta               :integer(2)      default(10), not null
#  bug_text_id       :integer(4)      default(0), not null
#  os                :string(32)      default(""), not null
#  os_build          :string(32)      default(""), not null
#  platform          :string(32)      default(""), not null
#  version           :string(64)      default(""), not null
#  fixed_in_version  :string(64)      default(""), not null
#  build             :string(32)      default(""), not null
#  profile_id        :integer(4)      default(0), not null
#  view_state        :integer(2)      default(10), not null
#  summary           :string(128)     default(""), not null
#  sponsorship_total :integer(4)      default(0), not null
#  sticky            :integer(1)      default(0), not null
#  target_version    :string(64)      default(""), not null
#  category_id       :integer(4)      default(1), not null
#  date_submitted    :integer(4)      default(1), not null
#  due_date          :integer(4)      default(1), not null
#  last_updated      :integer(4)      default(1), not null
#

