require "test_helper"

class FooTest < Test::Unit::TestCase

  def test_case_name
    doc = Nokogiri::XML(file_contents('stages.xml'))
    feed = GoApiClient::Atom::Feed.new(doc.root).parse!
    p feed.updated_at
    p feed.next_page
    p feed.url
    p feed.entries.first
    p feed.entries.last
  end

  def file_contents(file_name)
    File.read(File.expand_path("../../fixtures/#{file_name}", __FILE__))
  end

end
