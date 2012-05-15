require "test_helper"

module GoApiClient
  class CommitTest < Test::Unit::TestCase
    
    test "should parse a changeset xml node" do
      root = Nokogiri::XML.parse %q{<changeset changesetUri="http://localhost:8153/go/api/materials/1/changeset/9f77888d7a594699894a17f4d61fc9dfac3cfb74.xml">
        <user><![CDATA[oogabooga <twgosaas@gmail.com>]]></user>
        <checkinTime>2012-02-21T15:41:30+05:30</checkinTime>
        <revision><![CDATA[9f77888d7a594699894a17f4d61fc9dfac3cfb74]]></revision>
        <message><![CDATA[Update README]]></message>
        <file name="README" action="modified"/>
      </changeset>
      }
      
      commit = Commit.new(root).parse!

      assert_equal '9f77888d7a594699894a17f4d61fc9dfac3cfb74', commit.revision
      assert_equal 'Update README', commit.message
      assert_equal Time.parse("2012-02-21 10:11:30 UTC"), commit.time 
      assert_equal User.parse("oogabooga <twgosaas@gmail.com>"), commit.user
    end

  end
end
