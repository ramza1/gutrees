class AddAttachmentIconToBranches < ActiveRecord::Migration
  def self.up
    change_table :branches do |t|
      t.has_attached_file :icon
    end
  end

  def self.down
    drop_attached_file :branches, :icon
  end
end
