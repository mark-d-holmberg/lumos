include Warden::Test::Helpers

module FeatureHelpers
  def login(resource, scope, options={})
    Warden.test_mode!
    login_as resource, scope: scope, run_callbacks: options.try(:[], :callbacks)
    resource
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
