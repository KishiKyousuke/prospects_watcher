# Be sure to restart your server when you modify this file.
#
# This file eases your Rails 7.0 framework defaults upgrade.
#
# Uncomment each configuration one by one to switch to the new default.
# Once your application is ready to run with all new defaults, you can remove
# this file and set the `config.load_defaults` to `7.0`.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.
# https://guides.rubyonrails.org/upgrading_ruby_on_rails.html

# `button_to` view helper will render `<button>` element, regardless of whether
# or not the content is passed as the first argument or as a block.
Rails.application.config.action_view.button_to_generates_button_tag = true

# `stylesheet_link_tag` view helper will not render the media attribute by default.
Rails.application.config.action_view.apply_stylesheet_media_default = false

# Change the digest class for the key generators to `OpenSSL::Digest::SHA256`.
Rails.application.config.active_support.key_generator_hash_digest_class = OpenSSL::Digest::SHA256

# Change the digest class for ActiveSupport::Digest.
Rails.application.config.active_support.hash_digest_class = OpenSSL::Digest::SHA256

# Don't override ActiveSupport::TimeWithZone.name and use the default Ruby
# implementation.
Rails.application.config.active_support.remove_deprecated_time_with_zone_name = true

# Calls `Rails.application.executor.wrap` around test cases.
# This makes test cases behave closer to an actual request or job.
# Several features that are normally disabled in test, such as Active Record query cache
# and asynchronous queries will then be enabled.
Rails.application.config.active_support.executor_around_test_case = true

# Set both the `:open_timeout` and `:read_timeout` values for `:smtp` delivery method.
Rails.application.config.action_mailer.smtp_timeout = 5

# The ActiveStorage video previewer will now use scene change detection to generate
# better preview images (rather than the previous default of using the first frame
# of the video).
# Rails.application.config.active_storage.video_preview_arguments =
#   "-vf 'select=eq(n\\,0)+eq(key\\,1)+gt(scene\\,0.015),loop=loop=-1:size=2,trim=start_frame=1' -frames:v 1 -f image2"

# Automatically infer `inverse_of` for associations with a scope.
Rails.application.config.active_record.automatic_scope_inversing = true

# Raise when running tests if fixtures contained foreign key violations
# FactoryBot を使用しているためフィクスチャなし。N/A。
# Rails.application.config.active_record.verify_foreign_keys_for_fixtures = true

# Disable partial inserts.
# This default means that all columns will be referenced in INSERT queries
# regardless of whether they have a default or not.
Rails.application.config.active_record.partial_inserts = false

# Protect from open redirect attacks in `redirect_back_or_to` and `redirect_to`.
Rails.application.config.action_controller.raise_on_open_redirects = true

# Change the variant processor for Active Storage.
# 保留: ruby-vips 未インストール。Phase 4 (jsbundling 移行) 後に必要であれば対応。
# Rails.application.config.active_storage.variant_processor = :vips

# Enable parameter wrapping for JSON.
# Previously this was set in an initializer. It's fine to keep using that initializer if you've customized it.
# To disable parameter wrapping entirely, set this config to `false`.
Rails.application.config.action_controller.wrap_parameters_by_default = true

# Specifies whether generated namespaced UUIDs follow the RFC 4122 standard for namespace IDs provided as a
# `String` to `Digest::UUID.uuid_v3` or `Digest::UUID.uuid_v5` method calls.
Rails.application.config.active_support.use_rfc4122_namespaced_uuids = true

# Change the default headers to disable browsers' flawed legacy XSS protection.
Rails.application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-XSS-Protection' => '0',
  'X-Content-Type-Options' => 'nosniff',
  'X-Download-Options' => 'noopen',
  'X-Permitted-Cross-Domain-Policies' => 'none',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
}


# cache_format_version = 7.0 は config/application.rb に設定済み。


# Cookie serializer: 2 options
#
Rails.application.config.action_dispatch.cookies_serializer = :json

# Change the return value of `ActionDispatch::Request#content_type` to the Content-Type header without modification.
Rails.application.config.action_dispatch.return_only_request_media_type_on_content_type = false

# Active Storage `has_many_attached` relationships will default to replacing the current collection instead of appending to it.
# has_many_attached / has_one_attached を使用していないため N/A。
# Rails.application.config.active_storage.multiple_file_field_include_hidden = true

# disable_to_s_conversion は config/application.rb に設定済み。
