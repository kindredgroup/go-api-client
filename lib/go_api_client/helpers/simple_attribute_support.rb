module GoApiClient
  module Helpers
    module SimpleAttributesSupport
      def initialize(attributes={})
        attributes.each do |name, value|
          send("#{name}=", value) unless value.to_s.empty?
        end
      end
    end
  end
end
