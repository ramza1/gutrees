class BranchesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :admins, :sub_branches, :search]
  def index
    @branches = Branch.public_branches

    respond_to do |format|
      format.html # popular.html.erb
      format.json { render json: @branches }
    end
  end

  def sub_branches
    @branch = Branch.find_by_permalink(params[:id])
    @sub_branches = @branch.children.all
    @branches = Branch.all
    @branch_details = @branch
  end

  def admins
    @branch = Branch.find_by_permalink(params[:id])
    @can_edit = current_user.can_edit?(@branch) if current_user
    @branch_details = @branch
  end

  def search
    @q = params[:q]
    @branches = Branch.where("name LIKE ?", "%#{@q}%")
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
    @branch = Branch.find_by_permalink(params[:id])
    if @branch
      @branch_details = @branch
      @members = @branch.users.thumbnails
      @broadcasts = @branch.broadcasts.order("created_at desc").includes(:comments)
      @member_of = current_user.member_of?(@branch)  if current_user
      @branch.make_trend(ip = request.env['REMOTE_ADDR'])
      @broadcast = @branch.broadcasts.new
      impressionist(@branch)
      impression = @branch.impressionist_count(:filter=>:ip_address)
      @branch.countdown(impression)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @branch }
      end
    else
      respond_to do |format|
        format.html {redirect_to root_url, notice: "Sorry that branch does not exists"}
        format.json { render json: @branch }
      end
    end
  end

  # GET /branches/new
  # GET /branches/new.json
  def new
    @branch = Branch.new(parent_id: params[:branch_id])
    if params[:branch_id]
      @branch_details = Branch.find_by_permalink(params[:branch_id])
      @title = "Create a branch under #{@branch_details.name}"
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @branch }
    end
  end

  def privacy_settings
    @branch ||= Branch.find_by_permalink(params[:id])
    if current_user.can_edit?(@branch)
      @branch = Branch.find_by_permalink(params[:id])
    else
      render :text => t("You are not authorized to modify this branch"), :layout => true, :status => 401
    end
    @branch_details = @branch
  end

  # GET /branches/1/edit
  def edit
    @branch ||= Branch.find_by_permalink(params[:id])
    if current_user.can_edit?(@branch)
      @branch = Branch.find_by_permalink(params[:id])
    else
      render :text => t("You are not authorized to modify this branch"), :layout => true, :status => 401
    end
    @title = "Edit #{@branch.name}"
    @branch_details = @branch
  end
  # POST /branches
  # POST /branches.json
  def create
    @branch = Branch.new(params[:branch])
    @branch.user = current_user
    respond_to do |format|
      if @branch.save
        @branch.memberships.create({:user => current_user, :admin => true}, :as => :admin)
        format.html { redirect_to privacy_settings_branch_path(@branch) }
        format.json { render json: @branch, status: :created, location: @branch }
      else
        format.html { render action: "new" }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /branches/1
  # PUT /branches/1.json
  def update
    @branch = Branch.find_by_permalink(params[:id])

    respond_to do |format|
      if @branch.update_attributes(params[:branch])
        format.html { redirect_to edit_branch_path(@branch), notice: 'Branch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @branch = Branch.find_by_permalink(params[:id])
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to branches_url }
      format.json { head :no_content }
    end
  end

  def toggle_privacy
    @branch ||= Branch.find_by_permalink(params[:id])
    if current_user.can_edit?(@branch)
      @branch = Branch.find_by_permalink(params[:id])
      if @branch.private?
        @branch.update_attribute(:private, false)
        redirect_to :back
        flash[:notice] = "Now public brunch "
      else
        @branch.update_attribute(:private, true)
        redirect_to :back
        flash[:notice] = "Now private brunch "
      end
    else
      redirect_to branch_path(@branch)
      flash[:notice] = "Not authorised"
    end
    @branch_details = @branch
  end
end
