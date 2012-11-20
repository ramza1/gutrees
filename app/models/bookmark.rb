class Bookmark < ActiveRecord::Base
  belongs_to :user
  attr_accessible :booked_broadcast
  belongs_to :booked_broadcast, :class_name => 'Broadcast'
  validates_uniqueness_of :booked_broadcast_id, :scope => :user_id
  validates_presence_of :user_id, :booked_broadcast_id
end
