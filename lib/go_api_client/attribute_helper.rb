module GoApiClient
  class AttributeHelper
    def initialize(attributes={})
      attributes.each do |name, value|
        send("#{name}=", value) unless value.to_s.empty?
      end
    end
  end
end
