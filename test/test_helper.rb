require 'rubygems'
require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter "/.bundle/"
  add_filter "/bundle/"
  add_filter "/test/"
end

Bundler.require
require 'test/unit'
require 'go_api_client'
require 'ostruct'
require 'webmock/test_unit'

module WebMock
  class RequestStub
    attr_accessor :responses_sequences
  end
end
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
