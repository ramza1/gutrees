class AddPermalinkToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :permalink, :string
  end
end
