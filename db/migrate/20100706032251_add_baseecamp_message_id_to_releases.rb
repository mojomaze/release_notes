class AddBaseecampMessageIdToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :basecamp_message_id, :integer
  end

  def self.down
    remove_column :releases, :basecamp_message_id
  end
end
