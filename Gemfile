source 'http://rubygems.org'

#core
gem 'rails', '3.2.2'
gem 'sqlite3-ruby', :require => 'sqlite3'

# functionality
gem 'haml'
gem 'nokogiri'
gem 'jquery-rails', '>= 1.0.3'
gem 'kaminari'
gem 'stringex'
gem "rails-settings", :git => "git://github.com/100hz/rails-settings.git"

# Functionality

group :assets do
  gem 'therubyracer', :platforms => :ruby, :require => 'v8'
  gem 'less'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'thin'
  gem 'hirb'
  gem 'colored'
end

group :test do
  gem 'factory_girl'
end

group :development, :test do
  gem 'rspec-rails'
end

