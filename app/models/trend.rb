class Trend < ActiveRecord::Base
  belongs_to :branch, :counter_cache => true
  attr_accessible :ip, as: :admin
  validates_uniqueness_of :ip, :scope => :branch_id
  validates :ip, :branch_id, :presence => true
end
