require 'machinist/active_record'
require File.expand_path('../basecamp_helper', __FILE__)

Release.blueprint do
  basecamp_project_id { basecamp_project }
  mantis_project_id { mantis_project }
  basecamp_project_name { Faker::Lorem.words(1).first }
  mantis_project_name { Faker::Lorem.words(1).first }
  mantis_project_version_name { "1.0.0" }
  basecamp_message_category_id { basecamp_message_category } 
end
