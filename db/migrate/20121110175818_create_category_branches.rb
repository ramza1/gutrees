class CreateCategoryBranches < ActiveRecord::Migration
  def change
    create_table :category_branches do |t|
      t.belongs_to :category
      t.belongs_to :branch

      t.timestamps
    end
    add_index :category_branches, :category_id
    add_index :category_branches, :branch_id
  end
end
