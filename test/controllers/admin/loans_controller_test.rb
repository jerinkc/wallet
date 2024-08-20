require "test_helper"

class Admin::LoansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_loans_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_loans_show_url
    assert_response :success
  end
end
