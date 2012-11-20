class AddAncestryToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :ancestry, :string
    add_index :branches, :ancestry
  end
end
