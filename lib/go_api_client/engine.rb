module GoApiClient
  class Engine < ::Rails::Railtie

    config.after_initialize do
      GoApiClient.logger = Rails.logger
    end

  end
end
