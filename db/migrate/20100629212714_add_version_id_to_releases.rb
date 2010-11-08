class AddVersionIdToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :mantis_project_version_id, :integer
    add_column :releases, :mantis_project_version_name, :string
  end

  def self.down
    remove_column :releases, :mantis_project_version_id
    remove_column :releases, :mantis_project_version_name
  end
end
