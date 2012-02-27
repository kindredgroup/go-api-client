require 'test/unit'
require 'go_api_client/test'

require 'go_api_client'

require 'webmock/test_unit'

def file_contents(file_name)
  File.read(File.expand_path("../../fixtures/#{file_name}", __FILE__))
end


