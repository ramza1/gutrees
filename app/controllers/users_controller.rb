class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @broadcasts = @user.broadcasts.order("created_at desc").includes(:branch)
  end

 def branch_ins
  @user = User.find(params[:id])
  @branch_ins = @user.branches
 end

def my_branches
  @user = User.find(params[:id])
  @branches = @user.owned_branches
end

  def bookmarked_items
    @user = User.find(params[:id])
    @broadcasts = @user.booked_broadcasts
  end
end
