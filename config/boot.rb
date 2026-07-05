ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'logger' # Rails 6.1 + Ruby 3.2: Logger は stdlib gem 化されたため明示 require が必要

# webpacker 4.x の内部 YAML が alias を使っており Psych 4.0+ (Ruby 3.1+) で失敗するため暫定対処。
# bootsnap が YAML.load_file を上書きするため YAML compile cache を無効にし、
# 素の YAML.load_file に aliases: true を強制する。
# Phase 4 (webpacker 削除) 後にこのブロックごと消すこと。
require 'bootsnap'
Bootsnap.setup(
  cache_dir: "#{__dir__}/../tmp/cache",
  development_mode: ENV['RAILS_ENV'] == 'development',
  load_path_cache: true,
  compile_cache_iseq: true,
  compile_cache_yaml: false
)

require 'yaml'
module YAML
  class << self
    alias_method :load_file_without_aliases, :load_file
    def load_file(filename, **kwargs)
      load_file_without_aliases(filename, **kwargs.merge(aliases: true))
    end
  end
end
