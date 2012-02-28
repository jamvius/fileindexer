require 'test_helper'

class IndexedFilesControllerTest < ActionController::TestCase
  setup do
    @indexed_file = indexed_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:indexed_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create indexed_file" do
    assert_difference('IndexedFile.count') do
      post :create, indexed_file: @indexed_file.attributes
    end

    assert_redirected_to indexed_file_path(assigns(:indexed_file))
  end

  test "should show indexed_file" do
    get :show, id: @indexed_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @indexed_file
    assert_response :success
  end

  test "should update indexed_file" do
    put :update, id: @indexed_file, indexed_file: @indexed_file.attributes
    assert_redirected_to indexed_file_path(assigns(:indexed_file))
  end

  test "should destroy indexed_file" do
    assert_difference('IndexedFile.count', -1) do
      delete :destroy, id: @indexed_file
    end

    assert_redirected_to indexed_files_path
  end
end
