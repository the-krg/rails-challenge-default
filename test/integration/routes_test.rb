require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "route test" do
    assert_recognizes({ controller: "api/users", action: "index", format: :json }, { path: "api/users", method: :get })
    assert_recognizes({ controller: "api/users", action: "create", format: :json }, { path: "api/users", method: :post })
  end
end