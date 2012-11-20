class CreateTrends < ActiveRecord::Migration
  def change
    create_table :trends, force: true do |t|
      t.belongs_to :branch
      t.string :ip

      t.timestamps
    end
    add_index :trends, :branch_id
    add_column :branches, :trends_count, :integer, :default => 0
  end
end
