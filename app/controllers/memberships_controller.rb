class MembershipsController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  def index
    @branch = Branch.find_by_permalink(params[:branch_id])
    @can_edit = current_user.can_edit?(@branch) if current_user
    @requests = @branch.membership_requests
    @branch_details = @branch
  end
  # join group
  def create
    @branch = Branch.find_by_permalink(params[:branch_id])
    @user = current_user
    if @user.member_of?(@branch)
      flash[:notice] = "You are a member of this branch"
    elsif @branch.private?
      @branch.membership_requests.create(:user => current_user)
      flash[:warning] = t('groups.request_sent')
    else
      @branch.memberships.create({:user => @user}, as: :admin)
    end
    redirect_to :back
  end

  def update
    @branch = Branch.find_by_permalink(params[:branch_id])
    if current_user.can_edit?(@branch)
      @membership = @branch.memberships.find_or_create_by_user_id(params[:id])
      @membership.update_attribute :admin, !params[:promote].nil?
      flash[:notice] = 'settings saved'
      redirect_to :back
    else
      render :text => 'not authorized', :layout => true, :status => 401
    end
  end

  # leave group
  def destroy
    @branch = Branch.find_by_permalink(params[:branch_id])
    @membership = @branch.memberships.find_by_user_id(params[:id])
    if current_user.can_edit?(@branch) or @membership.try(:user) == current_user
      if @membership.user and @branch.last_admin?(@membership.user)
        flash[:warning] = 'This is the last admin and cannot be removed'
      else
        @membership.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def batch
    if params[:user_id]
      batch_on_person
    else
      batch_on_group
    end
  end

  def batch_on_person
    @user = User.find(params[:user_id])
    if current_user.can_edit?(@user) and current_user.admin?(:manage_groups)
      branches = (params[:ids] || []).map { |id| Branch.find(id) }
      # add groups
      (branches - @branch.users).each do |branch|
        branch.memberships.create(:user => @user)
      end
      # remove groups
      (@user.branches - branches).each do |branch|
        branch.memberships.find_by_user_id(@branch.id).destroy unless branch.last_admin?(@user)
      end
      @user.groups.reload
      respond_to do |format|
        format.js
      end
    else
      render :text => 'not authorized', :layout => true, :status => 401
    end
  end

  def batch_on_group
    @branch = Branch.find_by_permalink(params[:branch_id])
    branch_users = @branch.users
    if current_user.can_edit?(@branch)
      @can_edit = true
      if params[:ids] and params[:ids].is_a?(Array)
        @added = []
        params[:ids].each do |id|
          if request.post?
            user = User.find(id)
            unless params[:commit] == 'Ignore' or branch_users.include?(user)
              @branch.memberships.create({:user => user}, as: :admin)
              @added << user
            end
            @branch.membership_requests.find_all_by_user_id(id).each { |r| r.destroy }
          elsif request.delete?
            if @membership = @branch.memberships.find_by_user_id(id)
              @membership.destroy unless @branch.last_admin?(@membership.user)
            end
          end
        end
        respond_to do |format|
          format.js
          format.html { redirect_to :back }
        end
      else
        render :text => "You must specify a list of ids."
      end
    else
      render :text => 'not authorized', :layout => true, :status => 401
    end
  end
end