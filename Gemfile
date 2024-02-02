source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "bootsnap", require: false
gem "dotenv-rails"
gem "importmap-rails"
gem "jbuilder"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "rails-i18n"
gem "sassc-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "nokogiri"
end

group :development do
  gem "irb"
  gem "repl_type_completor"
  gem "solargraph"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
