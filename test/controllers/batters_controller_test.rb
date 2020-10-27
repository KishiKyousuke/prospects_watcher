require 'test_helper'

class BattersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get batters_index_url
    assert_response :success
  end

end
