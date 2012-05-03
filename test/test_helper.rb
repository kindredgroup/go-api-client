require 'simplecov'
SimpleCov.start

require 'test/unit'
require 'go_api_client'
require 'ostruct'
Dir["go_api_client/**/*.rb"].each {|f| require f}
require 'webmock/test_unit'

class Test::Unit::TestCase
  def file_contents(file_name)
    File.read(File.expand_path("../../test/fixtures/#{file_name}", __FILE__))
  end
end

module Test::Unit::Assertions
  def assert_false(test, failure_message = nil)
    assert(!test, failure_message || "Expected <#{test}> to be <false>.")
  end
end
