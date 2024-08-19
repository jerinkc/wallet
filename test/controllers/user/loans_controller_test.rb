require "test_helper"

class User::LoansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_loans_index_url
    assert_response :success
  end

  test "should get show" do
    get user_loans_show_url
    assert_response :success
  end
end
