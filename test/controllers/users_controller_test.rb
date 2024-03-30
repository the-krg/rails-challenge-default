require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  class IndexEndpoint < UsersControllerTest
    test "should get index" do
      get api_users_url

      assert_response :success

      assert_equal "index", @controller.action_name
    end

    test "should return all users on index endpoint" do
      get api_users_url

      user = users(:john)
      other_user = users(:paul)

      result = JSON.parse(@response.body)
      user_emails = result["users"].map { |u| u["email"] }

      assert_includes user_emails, user.email
      assert_includes user_emails, other_user.email
    end

    test "should return newest users first" do
      user = users(:john)
      other_user = users(:paul)
      new_user = User.new(email: 'new_user@user.com', phone_number: '333')
      new_user.password = 'password'
      new_user.save

      get api_users_url

      result = JSON.parse(@response.body)
      user_emails = result["users"].map { |u| u["email"] }

      assert_equal user_emails.first, new_user.email
    end

    class Filters < IndexEndpoint
      test "should return email filtered users" do
        user = users(:john)
        other_user = users(:paul)

        get api_users_url, params: { email: user.email }

        result = JSON.parse(@response.body)
        user_emails = result["users"].map { |u| u["email"] }

        assert_includes user_emails, user.email
        assert_not_includes user_emails, other_user.email
      end

      test "should return full name filtered users" do
        user = users(:john)
        other_user = users(:paul)

        get api_users_url, params: { full_name: other_user.full_name }

        result = JSON.parse(@response.body)
        user_emails = result["users"].map { |u| u["email"] }

        assert_includes user_emails, other_user.email
        assert_not_includes user_emails, user.email
      end

      test "should return metadata filtered users" do
        user = users(:john)
        other_user = users(:paul)

        get api_users_url, params: { metadata: user.metadata }

        result = JSON.parse(@response.body)
        user_emails = result["users"].map { |u| u["email"] }

        assert_includes user_emails, user.email
        assert_includes user_emails, other_user.email
      end

      test "should return combined filtered users" do
        user = users(:john)
        other_user = users(:paul)

        # ensure that one of the fields is equal (email is always different)
        other_user.full_name = user.full_name

        get api_users_url, params: { full_name: other_user.full_name, email: user.email }

        result = JSON.parse(@response.body)
        user_emails = result["users"].map { |u| u["email"] }

        assert_includes user_emails, user.email
        assert_not_includes user_emails, other_user.email
      end
    end
  end

end