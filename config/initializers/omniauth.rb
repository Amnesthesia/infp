Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :reddit, "mP60e63sOvpSTw", "6p8APJmUFDlQ_-DtnxsIe1nKlsw", {scope: 'read,identity'}
end
