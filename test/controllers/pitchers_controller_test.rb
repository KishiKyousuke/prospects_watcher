require 'test_helper'

class PitchersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pitchers_index_url
    assert_response :success
  end

end
