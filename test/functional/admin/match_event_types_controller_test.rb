require 'test_helper'

class MatchEventTypesControllerTest < ActionController::TestCase
=begin
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:match_event_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create match_event_type" do
    assert_difference('MatchEventType.count') do
      post :create, :match_event_type => { }
    end

    assert_redirected_to match_event_type_path(assigns(:match_event_type))
  end

  test "should show match_event_type" do
    get :show, :id => match_event_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => match_event_types(:one).to_param
    assert_response :success
  end

  test "should update match_event_type" do
    put :update, :id => match_event_types(:one).to_param, :match_event_type => { }
    assert_redirected_to match_event_type_path(assigns(:match_event_type))
  end

  test "should destroy match_event_type" do
    assert_difference('MatchEventType.count', -1) do
      delete :destroy, :id => match_event_types(:one).to_param
    end

    assert_redirected_to match_event_types_path
  end
=end
end
