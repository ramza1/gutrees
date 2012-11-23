class BroadcastsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  # GET /broadcasts/1
  # GET /broadcasts/1.json
  def show
    @broadcast = Broadcast.find(params[:id])
    @branch_details = @broadcast.branch

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @broadcast }
    end
  end

  # GET /broadcasts/new
  # GET /broadcasts/new.json
  def new
    @broadcast = Broadcast.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @broadcast }
    end
  end


  # POST /broadcasts
  # POST /broadcasts.json
  def create
    @branch = Branch.find_by_permalink(params[:branch_id])
    @broadcast = @branch.broadcasts.create(params[:broadcast])
    @broadcast.user = current_user

    respond_to do |format|
      if @broadcast.save
        format.html { redirect_to @broadcast, notice: 'Broadcast was successfully created.' }
        format.js
      else
        format.html { render action: "new" }
        format.js  {render 'error'}
      end
    end
  end



  # DELETE /broadcasts/1
  # DELETE /broadcasts/1.json
  def destroy
    @broadcast = Broadcast.find(params[:id])
    @broadcast.destroy

    respond_to do |format|
      format.html { redirect_to broadcasts_url }
      format.json { head :no_content }
    end
  end

  def bookmark
    @broadcast = Broadcast.find(params[:id])
    if current_user.bookmarked?(@broadcast)
      redirect_to @broadcast
      flash[:notice] = "This broadcast is already added to your bookmark list"
    else
      current_user.bookmark_item(@broadcast)
      redirect_to @broadcast
      flash[:notice] = "It has now be added to your bookmark list"
    end
  end

  def remove_bookmark
    if current_user.bookmark_item(@broadcast)
      @broadcast = Broadcast.find(params[:id])
      current_user.un_bookmark(@broadcast)
      redirect_to @broadcast
      flash[:notice] = "This broadcast is already added to your bookmark list"
    else
      raise "You have not bookmarked this broadcast"
    end
  end

  def toggle_flag
    @broadcast = Broadcast.find(params[:id])
    current_user.toggle_flag(@broadcast, :report)
    redirect_to @broadcast
    if current_user.flagged?(@broadcast, :report)
      flash[:notice] = "Reported"
    else
      flash[:notice] = "report Removed"

    end
  end
end