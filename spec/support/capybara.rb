# frozen_string_literal: true

require 'capybara/rspec'

RSpec.configure do |config|
  if ENV['SELENIUM_DRIVER_URL']
    config.before(:each, type: :system) do
      driven_by :selenium, using: :headless_chrome, options: {
        browser: :remote,
        url: ENV.fetch('SELENIUM_DRIVER_URL'),
        desired_capabilities: :chrome
      }
      Capybara.server_host = 'web'
      Capybara.app_host="http://#{Capybara.server_host}"
    end
  else
    config.before(:each, type: :system) do
      Capybara.register_driver :selenium_chrome_headless do |app|
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-gpu')
        options.add_argument('--window-size=1280,1024')

        Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
      end
      driven_by :selenium_chrome_headless
    end
  end
end
