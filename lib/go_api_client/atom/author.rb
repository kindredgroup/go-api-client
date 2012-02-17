module GoApiClient
  module Atom
    class Author
      attr_accessor :name, :email, :uri
      def initialize(root)
        @root = root
      end

      def parse!
        self.name     = @root.xpath('xmlns:name').first.content
        self.email    = @root.xpath('xmlns:email').first.content rescue nil
        self.uri      = @root.xpath('xmlns:uri').first.content   rescue nil
        @root = nil
        self
      end
    end
  end
end
