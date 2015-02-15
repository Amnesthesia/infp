Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :reddit, ENV['REDDIT_KEY'], ENV['REDDIT_SECRET']
end
