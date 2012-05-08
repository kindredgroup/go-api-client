module GoApiClient
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 9
    RELEASE = ENV['GO_PIPELINE_COUNTER']
    VERSION = [MAJOR, MINOR, PATCH, RELEASE].compact.join('.')
  end
end
