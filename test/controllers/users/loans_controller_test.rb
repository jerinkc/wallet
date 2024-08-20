require "test_helper"

class Users::LoansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_loans_index_url
    assert_response :success
  end

  test "should get show" do
    get users_loans_show_url
    assert_response :success
  end

  test "should get new" do
    get users_loans_new_url
    assert_response :success
  end

  test "should get create" do
    get users_loans_create_url
    assert_response :success
  end

  test "should get edit" do
    get users_loans_edit_url
    assert_response :success
  end

  test "should get update" do
    get users_loans_update_url
    assert_response :success
  end
end
