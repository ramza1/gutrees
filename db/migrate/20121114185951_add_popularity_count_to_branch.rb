class AddPopularityCountToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :popularity_count, :integer, default: 0
  end
end
