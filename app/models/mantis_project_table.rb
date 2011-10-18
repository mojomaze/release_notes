class MantisProjectTable < ActiveRecord::Base
  establish_connection "mantis"
  set_table_name "mantis_project_table"
  
  has_many :mantis_project_version_tables, :order => "date_order"
  has_many :mantis_bug_table, :order => "id"
  
end

# == Schema Information
#
# Table name: mantis_project_table
#
#  id             :integer(4)      not null, primary key
#  name           :string(128)     default(""), not null
#  status         :integer(2)      default(10), not null
#  enabled        :integer(1)      default(1), not null
#  view_state     :integer(2)      default(10), not null
#  access_min     :integer(2)      default(10), not null
#  file_path      :string(250)     default(""), not null
#  description    :text            default(""), not null
#  category_id    :integer(4)      default(1), not null
#  inherit_global :integer(4)      default(0), not null
#

