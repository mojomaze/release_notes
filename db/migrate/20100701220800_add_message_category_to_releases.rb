class AddMessageCategoryToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :basecamp_message_category_id, :integer
  end

  def self.down
    remove_column :releases, :basecamp_message_category_id
  end
end
