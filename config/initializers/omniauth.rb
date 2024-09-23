Rails.application.config.middleware.use OmniAuth::Builder do
  def require_env(key)
    ENV[key] or raise "Missing required environment variable: #{key}"
  end
  provider :google_oauth2, require_env("GOOGLE_CLIENT_ID"), require_env("GOOGLE_CLIENT_SECRET")
end
OmniAuth.config.allowed_request_methods = %i[post]

OmniAuth::AuthenticityTokenProtection.default_options(key: "csrf.token", authenticity_param: "_csrf")
