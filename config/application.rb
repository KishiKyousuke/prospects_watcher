require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProspectsWatcher
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end
    config.i18n.default_locale = :ja
    config.time_zone = 'Asia/Tokyo'
    config.active_support.cache_format_version = 7.0
    config.active_support.disable_to_s_conversion = true
  end
end
