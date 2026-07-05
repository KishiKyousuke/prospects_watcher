ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'logger' # Rails 6.1 + Ruby 3.2: Logger は stdlib gem 化されたため明示 require が必要
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
