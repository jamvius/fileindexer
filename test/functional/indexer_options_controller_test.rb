require 'test_helper'

class IndexerOptionsControllerTest < ActionController::TestCase
  setup do
    @indexer_option = indexer_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:indexer_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create indexer_option" do
    assert_difference('IndexerOption.count') do
      post :create, indexer_option: @indexer_option.attributes
    end

    assert_redirected_to indexer_option_path(assigns(:indexer_option))
  end

  test "should show indexer_option" do
    get :show, id: @indexer_option
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @indexer_option
    assert_response :success
  end

  test "should update indexer_option" do
    put :update, id: @indexer_option, indexer_option: @indexer_option.attributes
    assert_redirected_to indexer_option_path(assigns(:indexer_option))
  end

  test "should destroy indexer_option" do
    assert_difference('IndexerOption.count', -1) do
      delete :destroy, id: @indexer_option
    end

    assert_redirected_to indexer_options_path
  end
end
