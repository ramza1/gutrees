class AddCommentsCountToBroadcasts < ActiveRecord::Migration
  def change
    add_column :broadcasts, :comments_count, :integer, :default => 0
    add_column :branches, :broadcasts_count, :integer, :default => 0
  end
end
