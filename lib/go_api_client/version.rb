module GoApiClient
  module Version
    MAJOR = 1
    MINOR = 0
    PATCH = 0
    RELEASE = ENV['GO_PIPELINE_COUNTER']
    VERSION = [MAJOR, MINOR, PATCH, RELEASE].compact.join('.')
  end
end