module GoApiClient
  module Atom
    class Entry
      attr_accessor :authors, :id, :updated_at, :title

      def initialize(root)
        @root = root
      end

      def parse!
        self.updated_at = @root.xpath('xmlns:updated').first.content
        self.id         = @root.xpath('xmlns:id').first.content
        self.title      = @root.xpath('xmlns:title').first.content
        self.authors    = @root.xpath('xmlns:author').collect do |author|
          Author.new(author).parse!
        end
        @root = nil
        self
      end
    end
  end
end
