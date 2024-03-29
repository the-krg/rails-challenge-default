require 'test_helper'

class UserTest < ActiveSupport::TestCase
  presence_validations = ["email", "phone_number", "password", "key"]
  uniqueness_validations = ["email", "phone_number", "key", "account_key"]
  max_length_validations = { 
    email: 200, 
    phone_number: 20, 
    full_name: 200, 
    password: 100, 
    key: 100, 
    account_key: 100, 
    metadata: 2000,
  }

  test "saves users with all information filled" do
    user = users(:john)
    assert user.save
  end

  test "does not save users with no information" do
    user = User.new

    assert_not user.save
  end

  presence_validations.each do |required_attribute|
    test "must not save user without #{required_attribute}" do
      user = users(:john)
      user[required_attribute] = ''
  
      assert_not user.save
    end
  end

  uniqueness_validations.each do |unique_attribute|
    test "must not save user with #{unique_attribute} already in use" do
      user = users(:john)
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
end