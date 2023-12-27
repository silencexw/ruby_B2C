require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module B2C
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.autoload_paths += %W(#{config.root}/app/loggers)

    config.action_controller.allow_forgery_protection = true

    puts config.autoload_paths.inspect

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.assets false
      g.test_framework false
      g.skip_routes true
    end

    config.after_initialize do
      puts 'attach MyLogSubscriber to active_record 20231227'
      MyLogSubscriber.attach_to :active_record
    end
  end
end
