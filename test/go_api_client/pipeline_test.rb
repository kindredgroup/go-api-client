require "test_helper"

module GoApiClient
  class PipelineTest < Test::Unit::TestCase

    def setup
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
    end

    def test_fetch_populates_necessary_fields
      link = "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml"
      pipeline = GoApiClient::Pipeline.new(link)
      pipeline.fetch

      assert_equal "1", pipeline.label
      assert_equal ["Update README"], pipeline.commit_messages
    end

    def test_should_return_string_delimited_list_of_authors
      link = "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml"
      pipeline = GoApiClient::Pipeline.new(link).fetch
      author_foo = Atom::Author.new(nil)
      author_foo.name = 'foo'
      author_foo.email = 'foo@example.com'
      author_foo.uri =  'http://foo.example.com'

      author_bar = Atom::Author.new(nil)
      author_bar.name = 'bar'
      author_bar.email = 'bar@example.com'
      author_bar.uri =  'http://bar.example.com'

      pipeline.stages << OpenStruct.new(:authors => [author_foo, author_bar])
      assert_equal 'foo, bar', pipeline.authors
    end

  end
end
