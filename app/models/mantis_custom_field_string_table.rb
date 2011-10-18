class MantisCustomFieldStringTable < ActiveRecord::Base
  establish_connection "mantis"
  set_table_name "mantis_custom_field_string_table"
  
end

# == Schema Information
#
# Table name: mantis_custom_field_string_table
#
#  field_id :integer(4)      default(0), not null
#  bug_id   :integer(4)      default(0), not null
#  value    :string(255)     default(""), not null
#

