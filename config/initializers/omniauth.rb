OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '598985541053-hp181v5gbie668h1spt96fvsmu49c38l.apps.googleusercontent.com', 'ZlrDsJknWeVwvyaQ0EzNKQWK', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
