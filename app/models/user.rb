class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :image
  # attr_accessible :title, :body

  make_flagger
  has_many :memberships, :dependent => :destroy
  has_many :branches, :through => :memberships, :order => 'created_at desc'
  belongs_to :admin
  has_many :owned_branches, :class_name => "Branch", :foreign_key => 'user_id', :order => 'created_at desc'
  #has_many :broadcasts, :through => :branches
  has_many :broadcasts, :through => :branches,  :conditions => {:branches => {:private => false}}
  has_many :bookmarks
  has_many :booked_broadcasts, :through => :bookmarks
  has_many :all_broadcasts, :through => :branches

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20],
                         image: data["image"]
      )
    end
    user
  end


  def member_of?(branch)
    memberships.find_by_branch_id(branch.id)
  end

  def can_see?(*whats)
    whats.select do |what|
      case what.class.name
        when 'Branch'
          not (what.private?) or self.member_of?(what) or what.admin?(self)
        else
          raise "Unrecognized argument to can_see? (#{what.inspect})"
      end
    end.length == whats.length
  end

  alias_method :sees?, :can_see?




  def can_edit?(what)
    case what.class.name
      when 'Branch'
        what.admin?(self) or self.admin?(:manage_groups)
      when 'Membership'
        self.admin?(:manage_groups) or (what.branch and what.branch.admin?(self)) or self.can_edit?(what.user)
      else
        raise "Unrecognized argument to can_edit? (#{what.inspect})"
    end
  end

  def admin?(perm=nil)
    if perm
      admin and admin.flags[perm.to_s]
    else
      admin ? true : false
    end
  end

  def bookmark_item(broadcast)
    bookmark = bookmarks.build(:booked_broadcast => broadcast)
    if !bookmark.save
      logger.debug "already bookmarked this broadcast."
    end
  end

  def un_bookmark(broadcast)
    bookmark = Bookmark.first(:conditions => ["user_id = ? and booked_broadcast_id = ?", self.id, broadcast.id])
    if bookmark
      bookmark.destroy
    end
  end

  def bookmarked?(broadcast)
    self.booked_broadcasts.include? broadcast
  end


end
