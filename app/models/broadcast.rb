class Broadcast < ActiveRecord::Base
  belongs_to :branch, :counter_cache => true
  belongs_to :user
  attr_accessible :message, :title, :photo
  has_many :comments
  has_attached_file :photo, :styles => {:thumb => "400x400>"}
  scope :no_title, where(:title => nil)
  validates :message, :title, :presence => true

  after_create :send_mail_to_members
  make_flaggable :report


  def send_mail_to_members
    broadcast = self
    self.branch.users.find_each do |user|
       News.news_info(user, broadcast).deliver
    end
  end
end
