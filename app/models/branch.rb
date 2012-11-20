class Branch < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :name, :category_ids, :parent_id, :icon
  validates :name, :description, :user_id, :presence => true
  validates_uniqueness_of :name
  validates_uniqueness_of :permalink, :message => "Branch name has already been taken"

  is_impressionable

  has_ancestry
  has_many :memberships, :dependent => :destroy
  has_attached_file :icon, :styles => {:box => "50x80#", :thumb => "100x100#"}
  has_many :broadcasts
  has_many :membership_requests, :dependent => :destroy
  has_many :all_broadcasts, :class_name => "Broadcast", :foreign_key => "branch_id"
  has_many :users, :through => :memberships do
    def thumbnails
      # TODO figure out why select is changed to include people.*
      self.all(:select => 'users.id, users.name, users.image', :order => 'users.name')
    end
  end
  has_many :trends
  has_many :admins, :through => :memberships, :source => :user, :order => 'name', :conditions => ['memberships.admin = ?', true]
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :leader, :class_name => 'User', :foreign_key => 'leader_id'

  has_many :category_branches
  has_many :categories, :through => :category_branches
  scope :public_branches, where(:private => false).order("created_at desc")
  scope :popular, order("popularity_count desc")
  scope :trending, order("trends_count desc")
  scope :sponsored_branched, where(:sponsored => true).limit(6).order("created_at desc")
  scope :all_sponsored_branches, where(:sponsored => true).order("created_at desc")
  before_create :set_permalink

  def admin?(user, exclude_global_admins=false)
    if user
      if exclude_global_admins
        admins.include? user
      else
        user.admin?(:manage_groups) or admins.include? user
      end
    end
  end

  def to_param
    permalink
  end

  def last_admin?(user)
    user and admin?(user, :exclude_global_admins) and admins.length == 1
  end

  def branches_recommended
    categories.map { |category| category.branches - [self] }.flatten.uniq.sort
  end

  def countdown(score)
    update_trending_score(score)
  end

  def make_trend(ip)
    trend = trends.new({:ip => ip}, :as => :admin)
    if trend.valid?
      trend.save
    else
      logger.debug "Trend has been created"
    end
  end

  private
  def update_trending_score(impression)
    self.update_attribute(:popularity_count, impression)
  end

  def set_permalink
    self.permalink = name.downcase.gsub(/[^0-9a-z]+/, ' ').strip.gsub(' ', '-') if name
  end

end
