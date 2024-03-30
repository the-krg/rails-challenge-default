require 'test_helper'

class UserTest < ActiveSupport::TestCase
  class Validations < UserTest
    presence_validations = ["email", "phone_number"]
    uniqueness_validations = ["email", "phone_number", "key", "account_key"]
    max_length_validations = { 
      email: 200, 
      phone_number: 20, 
      full_name: 200, 
      key: 100, 
      account_key: 100, 
      metadata: 2000,
    }

    test "saves users with all information filled" do
      user = users(:john)
      user.password = 'password'

      assert user.save
    end

    test "does not save users with no information" do
      user = User.new

      assert_not user.save
    end

    presence_validations.each do |required_attribute|
      test "must not save user without #{required_attribute}" do
        user = users(:john)
        user.password = 'password'
        user[required_attribute] = ''
    
        assert_not user.save
      end
    end

    test "must not save user without password" do
      user = users(:john)
      user.password = ''

      assert_not user.save
    end

    uniqueness_validations.each do |unique_attribute|
      test "must not save user with #{unique_attribute} already in use" do
        user = users(:john)
        user.password = 'password'
        user.save

        new_user = users(:paul)
        new_user[unique_attribute] = user[unique_attribute]

        assert_not new_user.save
      end
    end

    max_length_validations.each do |attribute, max_length|
      test "#{attribute} length must not be more than #{max_length}" do
        user = users(:john)
        user[attribute] = 'x' * (max_length + 1)

        assert_not user.save
      end
    end

    test "password length must not be more than 100" do
      user = users(:john)
      user.password = "x" * 101

      assert_not user.save
    end
  end

  class Callbacks < UserTest
    test "should generate a random key when creating user" do
      user = User.new(email: 'test@example.com', phone_number: '000', key: nil)
      user.password = 'password'
      user.save

      assert user.key.present?
    end
  end

  class Search < UserTest
    test "when searching for email" do
      user = users(:john)

      query = { "email" => user.email }

      assert_equal(User.search(query), [user])
    end

    test "when searching for full_name" do
      user = users(:john)

      query = { "full_name" => user.full_name }

      assert_equal(User.search(query), [user])
    end

    test "when searching for metadata" do
      user = users(:john)
      other_user = users(:paul)

      query = { "metadata" => user.metadata }

      assert_equal(User.search(query), [user, other_user])
    end

    test "when searching for multiple attributes" do
      user = users(:john)
      other_user = users(:paul)

      query = { "email" => user.email, "full_name" => user.full_name, "metadata" => user.metadata }

      assert_includes(User.search(query), user)
      assert_not_includes(User.search(query), other_user)
    end

    test "when injecting sql queries to value" do
      user = users(:john)

      query = { "email" => "#{user.email}';update users set password='0'--" }

      assert_not_includes(User.search(query), user)
      assert_not_equal(user.password, 0)
    end
  end
end