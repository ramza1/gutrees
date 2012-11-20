class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks, force: true do |t|
      t.belongs_to :user
      t.integer :booked_broadcast_id

      t.timestamps
    end
    add_index :bookmarks, :user_id
    add_index :bookmarks, :booked_broadcast_id
  end
end
