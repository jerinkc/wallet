require "test_helper"

class AccountSummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get account_summary_show_url
    assert_response :success
  end
end
