class AddCompanyIdToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :basecamp_company_id, :integer
  end

  def self.down
    remove_column :releases, :basecamp_company_id
  end
end
