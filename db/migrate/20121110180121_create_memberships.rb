class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :branch
      t.belongs_to :user
      t.boolean :admin, default: false
      t.integer :code
      t.boolean :auto

      t.timestamps
    end
    add_index :memberships, :branch_id
    add_index :memberships, :user_id
  end
end
