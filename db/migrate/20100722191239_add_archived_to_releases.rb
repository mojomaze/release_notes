class AddArchivedToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :releases, :archived
  end
end
