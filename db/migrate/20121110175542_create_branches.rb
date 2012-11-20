class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.text :description
      t.integer :memberships_count, default: 0
      t.belongs_to :user
      t.boolean :private, default: false

      t.timestamps
    end
    add_index :branches, :user_id
  end
end
