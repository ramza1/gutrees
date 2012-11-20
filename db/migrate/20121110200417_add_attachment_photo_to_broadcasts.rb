class AddAttachmentPhotoToBroadcasts < ActiveRecord::Migration
  def self.up
    change_table :broadcasts do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :broadcasts, :photo
  end
end
