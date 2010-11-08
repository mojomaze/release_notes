class AddUserIdToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :user_id, :integer
  end

  def self.down
    remove_column :releases, :user_id
  end
end
