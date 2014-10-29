require 'go_api_client/logger'
require 'go_api_client/version'

module GoApiClient
  autoload :Client, 'go_api_client/client'
  autoload :HttpFetcher, 'go_api_client/http_fetcher'
  autoload :Engine, 'go_api_client/engine' if defined?(::Rails)
  autoload :AttributeHelper, 'go_api_client/attribute_helper'

  module Api
    autoload :AbstractApi, 'go_api_client/api/abstract_api'
    autoload :Cctray, 'go_api_client/api/cctray'
    autoload :Pipeline, 'go_api_client/api/pipeline'
    autoload :Feed, 'go_api_client/api/feed'
    autoload :Job, 'go_api_client/api/job'
    autoload :Stage, 'go_api_client/api/stage'
  end

  module Domain
    autoload :Author, 'go_api_client/domain/author'
    autoload :Artifact, 'go_api_client/domain/artifact'
    autoload :Changeset, 'go_api_client/domain/changeset'
    autoload :Entry, 'go_api_client/domain/entry'
    autoload :Feed, 'go_api_client/domain/feed'
    autoload :InternalCache, 'go_api_client/domain/internal_cache'
    autoload :Job, 'go_api_client/domain/job'
    autoload :ScheduledJob, 'go_api_client/domain/scheduled_job'
    autoload :Pipeline, 'go_api_client/domain/pipeline'
    autoload :Stage, 'go_api_client/domain/stage'
    autoload :Material, 'go_api_client/domain/material'
    autoload :Project, 'go_api_client/domain/project'
    autoload :User, 'go_api_client/domain/user'
  end

  module Parsers
    autoload :Author, 'go_api_client/parsers/author_parser'
    autoload :Artifact, 'go_api_client/parsers/artifact_parser'
    autoload :Changeset, 'go_api_client/parsers/changeset'
    autoload :Material, 'go_api_client/parsers/material_parser'
    autoload :Job, 'go_api_client/parsers/job_parser'
    autoload :ScheduledJob, 'go_api_client/parsers/scheduled_job_parser'
    autoload :Helper, 'go_api_client/parsers/parser_helper'
    autoload :Pipeline, 'go_api_client/parsers/pipeline_parser'
    autoload :Stage, 'go_api_client/parsers/stage_parser'
    autoload :Author, 'go_api_client/parsers/author_parser'
    autoload :Entry, 'go_api_client/parsers/entry_parser'
    autoload :Feed, 'go_api_client/parsers/feed_parser'
    autoload :Project, 'go_api_client/parsers/project_parser'
    autoload :User, 'go_api_client/parsers/user_parser'
  end
end