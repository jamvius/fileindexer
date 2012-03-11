require 'test_helper'

class StatusTasksControllerTest < ActionController::TestCase
  setup do
    @status_task = status_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:status_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create status_task" do
    assert_difference('StatusTask.count') do
      post :create, status_task: @status_task.attributes
    end

    assert_redirected_to status_task_path(assigns(:status_task))
  end

  test "should show status_task" do
    get :show, id: @status_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @status_task
    assert_response :success
  end

  test "should update status_task" do
    put :update, id: @status_task, status_task: @status_task.attributes
    assert_redirected_to status_task_path(assigns(:status_task))
  end

  test "should destroy status_task" do
    assert_difference('StatusTask.count', -1) do
      delete :destroy, id: @status_task
    end

    assert_redirected_to status_tasks_path
  end
end
