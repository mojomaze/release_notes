require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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

