require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FashionStore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths += %W[
      #{config.root}/lib/concerns
      #{config.root}/lib/error
      #{config.root}/app/services
      #{config.root}/app/interactors
      #{config.root}/app/workers
      #{config.root}/app/serializers
      #{config.root}/app/mailers
      #{config.root}/app/adapters
    ]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = %i[en vi]
    config.i18n.default_locale = :en
    config.time_zone = 'Asia/Ho_Chi_Minh'

    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)

    config_file = Rails.application.config_for(:application)
    config_file.each do |key, value|
      ENV[key.to_s] = value
    end unless config_file.nil?

    # This tells Rails to serve error pages from the Rails app itself (i.e. the routes we just set up), rather than using static error pages
    config.exceptions_app = self.routes
    # Rails.application.configure do
    #   config.hosts << 'b97a-222-253-42-176.ap.ngrok.io'
    # end
  end
end
