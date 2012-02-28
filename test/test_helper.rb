require 'test/unit'
require 'go_api_client'
Dir["go_api_client/**/*.rb"].each {|f| require f} 
require 'webmock/test_unit'

def file_contents(file_name)
  File.read(File.expand_path("../../test/fixtures/#{file_name}", __FILE__))
end


