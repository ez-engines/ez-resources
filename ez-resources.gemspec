# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'ez/resources/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ez-resources'
  s.version     = Ez::Resources::VERSION
  s.authors     = ['Volodya Sveredyuk']
  s.email       = ['sveredyuk@gmail.com']
  s.homepage    = 'https://github.com/ez-engines/ez-resources'
  s.summary     = 'Easy resources engine for Rails app.'
  s.description = 'Easy resources engine for Rails app.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'cells-rails', '~> 0.1.0'
  s.add_dependency 'cells-slim',  '~> 0.0.6'
  s.add_dependency 'ez-core',     '~> 0.2'
  s.add_dependency 'pagy',        '~> 4.3'
  s.add_dependency 'rails',       '>= 5.2', '<= 7.0'
  s.add_dependency 'ransack',     '~> 2.3'
  s.add_dependency 'simple_form', '>= 5.0.1'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
