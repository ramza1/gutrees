class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.belongs_to :branch
      t.belongs_to :user
      t.text :message
      t.string :title

      t.timestamps
    end
    add_index :broadcasts, :branch_id
    add_index :broadcasts, :user_id
  end
end
