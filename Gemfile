source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.5'

gem 'rails', '~> 6.1'
gem 'sqlite3', '~> 1.6'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.15', require: false

gem 'rails_admin', '~> 2.2.1'
gem 'devise', '~> 4.8.0'
gem 'paper_trail', '~> 12.0.0'
gem 'pg', '~> 1.4'
gem 'connection_pool'
gem 'aws-sdk-s3', '~> 1.96.1'
gem "honeybadger", "~> 4.0"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "minitest-rails", "~> 6.1.0"
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

gem "dockerfile-rails", ">= 1.0.0", :group => :development
