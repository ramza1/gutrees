require 'test_helper'

class BranchesControllerTest < ActionController::TestCase
  setup do
    @branch = branches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:branches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create branch" do
    assert_difference('Branch.count') do
      post :create, branch: { description: @branch.description, memberships_count: @branch.memberships_count, name: @branch.name, private: @branch.private }
    end

    assert_redirected_to branch_path(assigns(:branch))
  end

  test "should show branch" do
    get :show, id: @branch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @branch
    assert_response :success
  end

  test "should update branch" do
    put :update, id: @branch, branch: { description: @branch.description, memberships_count: @branch.memberships_count, name: @branch.name, private: @branch.private }
    assert_redirected_to branch_path(assigns(:branch))
  end

  test "should destroy branch" do
    assert_difference('Branch.count', -1) do
      delete :destroy, id: @branch
    end

    assert_redirected_to branches_path
  end
end
