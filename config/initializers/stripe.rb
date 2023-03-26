Stripe.api_key = Settings.stripe.secret_key
Stripe.api_version = '2022-08-01'
Rails.application.configure do
  config.stripe.secret_key = Settings.stripe.secret_key
  config.stripe.publishable_key = Settings.stripe.publisable_key
end