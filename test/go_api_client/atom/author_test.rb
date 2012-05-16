require "test_helper"

module GoApiClient
  module Atom
    class AuthorTest < Test::Unit::TestCase

      test "should be able to parse author's info" do
        doc = Nokogiri::XML(%Q{<author xmlns="http://www.w3.org/2005/Atom"><name><![CDATA[oogabooga <twgosaas@gmail.com>]]></name><uri>http://oogabooga.example.com<uri></author>})
        author = Author.new(doc.root).parse!
        assert_equal Author.new(nil, :name => 'oogabooga', :email => 'twgosaas@gmail.com', :uri => 'http://oogabooga.example.com'), author
      end

      test "should be able to parse author xml with no email and uri" do
        doc = Nokogiri::XML(%Q{<author xmlns="http://www.w3.org/2005/Atom"><name><![CDATA[oogabooga]]></name></author>})
        author = Author.new(doc.root).parse!
        assert_equal Author.new(nil, :name => 'oogabooga'), author
      end

      test "should be able to parse author xml with email specified in the name tag" do
        doc = Nokogiri::XML(%Q{<author xmlns="http://www.w3.org/2005/Atom"><name><![CDATA[oogabooga <twgosaas@gmail.com>]]></name></author>})
        author = Author.new(doc.root).parse!
        assert_equal Author.new(nil, :name => 'oogabooga', :email => 'twgosaas@gmail.com'), author
      end

    end
  end
end
