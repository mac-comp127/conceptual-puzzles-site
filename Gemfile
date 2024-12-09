source "https://rubygems.org"

gem "nokogiri", "~> 1.17.0"  # Nokogiri 16 causes "wrong ELF class" error on Ubuntu?!

gem "rails", "~> 7.2.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "turbo-rails"     # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "stimulus-rails"  # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "jbuilder"        # Build JSON APIs [https://github.com/rails/jbuilder]

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# View template languages
gem "haml-rails", "~> 2.1"
gem "dartsass-rails", "~> 0.5.1"

# Background jobs
gem "que", "~> 2.4"

# Google login
gem "omniauth-google-oauth2", "~> 1.2"
gem "omniauth-rails_csrf_protection", "~> 1.0"

# For email address parsing
gem "mail", "~> 2.8"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # For fake_data rake task
  gem "ffaker", "~> 2.23"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
