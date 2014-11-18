require 'test_helper'

module GoApiClient
  module Atom
    class EntryTest < Test::Unit::TestCase
      setup do
        doc = Nokogiri::XML(file_contents('pagination/stages.xml'))
        @root = doc.root
        @entry_node = @root.xpath('./xmlns:entry')[12]
      end

      test 'should parse entry node' do
        entry = GoApiClient::Parsers::Entry.parse(@entry_node)
        assert_equal 'https://go-server.example.com/go/pipelines/tlb/177/ant_count_go/1', entry.id
        assert_equal Time.parse('2012-01-22 11:32:57 UTC'), entry.updated
        assert_equal 'tlb(177) stage ant_count_go(1) Passed', entry.title
        assert_equal 'https://go-server.example.com/go/api/stages/210161.xml', entry.stage_uri
        expected_authors = [
          GoApiClient::Domain::Author.new({:name => 'Pavan', :email => 'itspanzi@gmail.com'}),
          GoApiClient::Domain::Author.new({:name => 'Pavan Sudarshan', :email => 'itspanzi@gmail.com'})
        ]

        assert_equal expected_authors, entry.parsed_authors
      end
    end
  end
end
