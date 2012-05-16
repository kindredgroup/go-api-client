require 'time'

module GoApiClient
  module Atom
    class Entry

      attr_accessor :authors, :id, :updated_at, :title, :stage_href, :pipelines

      include GoApiClient::Helpers::SimpleAttributesSupport

      def initialize(root, attributes={})
        @root = root
        super(attributes)
      end

      def parse!
        self.updated_at = Time.parse(@root.xpath('xmlns:updated').first.content).utc
        self.id         = @root.xpath('xmlns:id').first.content
        self.title      = @root.xpath('xmlns:title').first.content
        self.stage_href = @root.
          xpath("xmlns:link[@type='application/vnd.go+xml' and  @rel='alternate']").
          first.
          attributes["href"].value

        self.authors    = @root.xpath('xmlns:author').collect do |author|
          Author.new(author).parse!
        end
        @root = nil
        self
      end
    end
  end
end

