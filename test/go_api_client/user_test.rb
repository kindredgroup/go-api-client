require "test_helper"

module GoApiClient
  class UserTest < Test::Unit::TestCase

    test "should parse user name and email address" do
      user = User.parse("foobar <foo@example.com>")
      assert_equal 'foobar', user.name
      assert_equal 'foo@example.com', user.email
    end

    test "should strip name and email when parsing" do
      user = User.parse("foobar1                         <foo1@example.com>")
      assert_equal 'foobar1', user.name
      assert_equal 'foo1@example.com', user.email      
    end

    test "equality" do
      assert_equal User.parse("foobar <foo@example.com>"), User.parse("foobar <foo@example.com>")
    end
  end
end
