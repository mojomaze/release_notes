class MantisCustomFieldStringTable < ActiveRecord::Base
  establish_connection "mantis"
  set_table_name "mantis_custom_field_string_table"
  
end
