source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem 'pundit'
gem "devise"
gem 'audited'
gem 'friendly_id', '~> 5.2.4'

gem 'bootstrap_form', git: 'https://github.com/bootstrap-ruby/bootstrap_form.git', branch: 'bootstrap-5'
gem 'font_awesome5_rails'

# XLSX sheet
gem 'spreadsheet'
gem 'yaml_db'

# PDF
gem 'prawn', '1.3'
gem 'prawn-table', '~> 0.1.0'

# Sucker Punch is a Ruby asynchronous processing library using concurrent-ruby

# Ruby finite-state-machine-inspired API for modeling workflow 
gem 'workflow'
gem 'workflow-activerecord'

# 
gem 'exception_notification'
gem 'sitemap_generator'
gem 'capture_stdout'

gem 'aws-sdk-s3', require: false

gem 'meta-tags'

# ActiveStorage Service to store files PostgeSQL.
gem 'active_storage-postgresql'

gem 'dotenv-rails', groups: [:development, :test]

# This gem provides helper methods for the reCAPTCHA API
gem 'recaptcha'

gem 'kaminari'
gem 'bootstrap4-kaminari-views'

gem "mailgun-ruby", "~> 1.2"

gem "sortable-for-rails", "~> 1.2"

gem "page_title_helper", "~> 6.0"

gem "importmap-rails", "~> 1.1"

gem "bootstrap", "~> 5.2"

gem "rack-attack", "~> 6.6"
