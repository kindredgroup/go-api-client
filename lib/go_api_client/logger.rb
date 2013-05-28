require 'logger'

module GoApiClient
  class <<self
    attr_accessor :logger
  end

  self.logger = ::Logger.new(STDERR)
end
