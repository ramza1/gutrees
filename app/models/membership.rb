class Membership < ActiveRecord::Base
  belongs_to :branch, :counter_cache => true
  belongs_to :user
  attr_accessible :auto, :code
  attr_accessible :admin, :user, :as => :admin
  validates_uniqueness_of :branch_id, :scope => [:user_id]

  before_create :generate_security_code

  def generate_security_code
    begin
      code = rand(999999)
      write_attribute :code, code
    end until code > 0
  end
end
