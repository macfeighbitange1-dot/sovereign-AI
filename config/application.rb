require_relative "boot"

require "rails/all"
require "rails_event_store" # <--- Force load the Event Store Engine

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module MySovereignAi
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 8.0
    config.load_defaults 8.0

    # Ensure our custom logic (Events & Services) is automatically loaded by Rails
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Nairobi Node Optimization: Add events and services to the eager load paths
    config.eager_load_paths << Rails.root.join("app", "events")
    config.eager_load_paths << Rails.root.join("app", "services")

    # Configuration for the application, engines, and railties.
    # Settings in config/environments take precedence over those specified here.
    
    # Set Nairobi as the default time zone for accurate ledger timestamps
    config.time_zone = "Nairobi"
  end
end
