class AddNamesToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :basecamp_project_name, :string
    add_column :releases, :mantis_project_name, :string
  end

  def self.down
    remove_column :releases, :mantis_project_name
    remove_column :releases, :basecamp_project_name
  end
end
