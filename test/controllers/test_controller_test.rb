require 'test_helper'

class TestControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get test_test_url
    assert_response :success
  end

  test "should get test_one" do
    get test_test_one_url
    assert_response :success
  end

  test "should get test_two" do
    get test_test_two_url
    assert_response :success
  end

end
