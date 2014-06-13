require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lumos
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Email Regex
    # https://gist.github.com/343843
    config.email_regex = /\A(?:[a-z\d!#\$%&'\*\+\-\/=\?\^_`\{\|\}~]+|\.)+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\z/i

    # Customize the generators
    config.generators do |g|
      g.hidden_namespaces << :test_unit << :erb
      g.test_framework :rspec, fixture: false, view_specs: false
      g.integration_tool :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
      g.stylesheet_engine :scss
      g.assets false
      g.helper false
      g.request_specs false
    end
  end
end
