class AddLeaderIdToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :leader_id, :integer
  end
end
