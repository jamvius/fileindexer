require 'test_helper'

class IndexedDirectoriesControllerTest < ActionController::TestCase
  setup do
    @indexed_directory = indexed_directories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:indexed_directories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create indexed_directory" do
    assert_difference('IndexedDirectory.count') do
      post :create, indexed_directory: @indexed_directory.attributes
    end

    assert_redirected_to indexed_directory_path(assigns(:indexed_directory))
  end

  test "should show indexed_directory" do
    get :show, id: @indexed_directory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @indexed_directory
    assert_response :success
  end

  test "should update indexed_directory" do
    put :update, id: @indexed_directory, indexed_directory: @indexed_directory.attributes
    assert_redirected_to indexed_directory_path(assigns(:indexed_directory))
  end

  test "should destroy indexed_directory" do
    assert_difference('IndexedDirectory.count', -1) do
      delete :destroy, id: @indexed_directory
    end

    assert_redirected_to indexed_directories_path
  end
end
