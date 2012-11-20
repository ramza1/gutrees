class AddSponsoredToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :sponsored, :boolean, default:false
  end
end
