class MantisProjectTable < ActiveRecord::Base
  establish_connection "mantis"
  set_table_name "mantis_project_table"
  
  has_many :mantis_project_version_tables, :order => "date_order"
  has_many :mantis_bug_table, :order => "id"
  
end
