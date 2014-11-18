module GoApiClient
  module Parsers
    class Helper
      class << self
        def href_from(xml)
          xml.first.attribute('href').value unless xml.empty?
        end
      end
    end
  end
end
