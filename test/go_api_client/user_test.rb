require 'test_helper'

module GoApiClient
  class UserTest < Test::Unit::TestCase
    test 'should parse user name and email address' do
      doc = Nokogiri::XML.parse %q{<user><![CDATA[Foo Bar <foo.bar@example.com>]]></user>}
      user = GoApiClient::Parsers::User.parse(doc.root)
      assert_equal 'Foo Bar', user.name
      assert_equal 'foo.bar@example.com', user.email
    end
    test 'equality' do
      doc = Nokogiri::XML.parse %q{<user><![CDATA[Foo Bar <foo.bar@example.com>]]></user>}
      assert_equal GoApiClient::Parsers::User.parse(doc.root), GoApiClient::Parsers::User.parse(doc.root)
    end
    test 'hashcode' do
      doc1 = Nokogiri::XML.parse %q{<user><![CDATA[Foo Bar <foo.bar@example.com>]]></user>}
      doc2 = Nokogiri::XML.parse %q{<user><![CDATA[Foo Bar <foo@bar.com>]]></user>}
      assert_equal GoApiClient::Parsers::User.parse(doc1.root).hash, GoApiClient::Parsers::User.parse(doc1.root).hash
      assert_not_equal GoApiClient::Parsers::User.parse(doc1.root).hash, GoApiClient::Parsers::User.parse(doc2.root).hash
    end
  end
end