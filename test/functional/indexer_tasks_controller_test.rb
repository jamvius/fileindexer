require 'test_helper'

class IndexerTasksControllerTest < ActionController::TestCase
  setup do
    @indexer_task = indexer_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:indexer_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create indexer_task" do
    assert_difference('IndexerTask.count') do
      post :create, indexer_task: @indexer_task.attributes
    end

    assert_redirected_to indexer_task_path(assigns(:indexer_task))
  end

  test "should show indexer_task" do
    get :show, id: @indexer_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @indexer_task
    assert_response :success
  end

  test "should update indexer_task" do
    put :update, id: @indexer_task, indexer_task: @indexer_task.attributes
    assert_redirected_to indexer_task_path(assigns(:indexer_task))
  end

  test "should destroy indexer_task" do
    assert_difference('IndexerTask.count', -1) do
      delete :destroy, id: @indexer_task
    end

    assert_redirected_to indexer_tasks_path
  end
end
