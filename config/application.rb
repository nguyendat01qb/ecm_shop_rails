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
    config.autoload_paths << config.root.join('lib')
    config.autoload_paths << config.root.join('lib/concerns')
    config.autoload_paths << config.root.join('app/serializers')
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = %i[en vi]
    config.i18n.default_locale = :en
    config.time_zone = 'Asia/Ho_Chi_Minh'

    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)

    config_file = Rails.application.config_for(:application)
    config_file.each do |key, value|
      ENV[key.to_s] = value
    end unless config_file.nil?

    # Rails.application.configure do
    #   config.hosts << 'b97a-222-253-42-176.ap.ngrok.io'
    # end
  end
end
