require 'logger'

module GoApiClient
  class <<self
    attr_accessor :logger
  end

  if defined?(Rails.logger)
    self.logger = Rails.logger
  else
    self.logger = ::Logger.new(STDERR)
  end
end
