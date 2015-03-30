SmsSubscriptions::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address:              'smtp01.binero.se',
      port:                  587,
      domain:               'realmobile.se',
      :user_name            => 'sms@realmobile.se',
      :password             => 'Ch4ngmyLife',
      :authentication       => :login,
  }

  config.action_mailer.default_url_options = {:host => "54.69.3.56"}
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  ActiveSupport::Dependencies.autoload_paths << File::join( Rails.root, 'lib')

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
        :login => "vickypedia.p_api1.gmail.com",
        :password => "T3AF736NPUKKRVHZ",
        :signature => "A7C.wSthdJc-XnRjqtJQ9wKVbQ6qAXkm-quWpNgnWbIAQevKZC-pPWD9",
        :method => "SetExpressCheckout"
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end
