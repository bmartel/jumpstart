require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("vine-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/bmartel/vine.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{vine/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def set_application_config
  application do
  <<-'RUBY'
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.stylesheets false
      g.javascripts false
    end
  RUBY
  end

  environment "config.force_ssl = true"
  environment "config.hosts << ENV['APP_DOMAIN']"
  environment "config.active_storage.variant_processor = :vips"
  environment "config.cache_store = :redis_cache_store, { url: \"\#{ENV['REDIS_URL']}/0\" }"
end

def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.module_parent_name"
end

def setup_pg
  generate "pg_search:migration:multisearch"

  insert_into_file Dir["db/migrate/**/*create_pg_search_documents.rb"].first, after: "  def self.up\n" do
    <<-'RUBY'

    enable_extension 'pg_trgm'
    enable_extension 'fuzzystrmatch'
    enable_extension 'unaccent'
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'
    RUBY
  end
end

def setup_rspec
  generate "rspec:install"
end

def setup_headless_chrome
  insert_into_file "spec/spec_helper.rb", before: "RSpec.configure do |config|" do
  <<-'RUBY'
  require 'capybara/rspec'
  require 'selenium-webdriver'

  Capybara.register_driver :chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(
      args: %w[headless disable-gpu no-sandbox]
    )
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :chrome

  RUBY
  end
end

def add_storage
  rails_command "active_storage:install"

  environment "config.active_storage.service = :amazon",
              env: 'development'

  environment "config.active_storage.service = :amazon",
              env: 'production'
end

def add_passwordless
  generate "passwordless:install:migrations"
  # Install Pundit policies
  generate "pundit:install"

  # Configure Dev Mailer
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
end

def copy_templates
  FileUtils.rm_rf(Dir['db/*']) # clear the generated db dir
  directory "app", force: true
  directory "db", force: true
  directory "config", force: true
  directory "lib", force: true
  directory "docker", force: true
  copy_file "Dockerfile", force: true
  copy_file "docker-compose.yml", force: true
  copy_file "docker-compose.dev.yml", force: true
  copy_file "docker-compose.prod.yml", force: true
  copy_file ".dockerignore", force: true
  copy_file "postcss.config.js", force: true
  copy_file ".eslintrc.js", force: true
  copy_file ".browserslistrc", force: true
  copy_file ".prettierrc", force: true
  copy_file ".gitignore", force: true
  copy_file ".eslintignore", force: true
  copy_file ".editorconfig", force: true
  copy_file ".env", force: true
  run 'chmod +x docker/start.sh'
  run 'chmod +x docker/nginx/start.sh'
end

def add_webpack
  # rails_command 'webpacker:install'
  gsub_file "config/environments/development.rb",
    /config.webpacker.check_yarn_integrity = true/,
    "config.webpacker.check_yarn_integrity = false"
end

def add_stimulus
  rails_command 'webpacker:install:stimulus'
  rails_command 'stimulus_reflex:install'
end

def add_npm_packages
  run 'yarn add --dev purgecss-webpack-plugin'
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"
end

def add_foreman
  copy_file "Procfile"
end

def add_gems
  gem 'stimulus_reflex'
  gem 'enumerize'
  gem 'pagy'
  gem 'pg_search'
  gem 'pundit'
  gem 'passwordless'
  # gem 'doorkeeper'
  gem 'gravtastic'
  gem 'sidekiq'
  gem 'foreman'
  gem 'redis'
  gem 'image_processing'
  gem "aws-sdk-s3", require: false
  gem 'whenever', require: false
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'factory_bot_rails'
    gem 'faker'
  end
end

def add_doorkeeper
  generate "doorkeeper:install"
  generate "doorkeeper:migration"
end

def add_whenever
  run "wheneverize ."
end

def stop_spring
  run "spring stop"
end

def setup_git_repository
  FileUtils.rm_rf(Dir['.git/*']) # clear the original
  git :init
  git add: "."
end

# Main setup
add_template_repository_to_source_path
add_gems

after_bundle do
  set_application_config
  set_application_name
  stop_spring
  setup_rspec
  setup_headless_chrome
  setup_pg
  add_storage
  add_passwordless
  # add_doorkeeper
  add_sidekiq
  add_foreman
  add_webpack
  add_stimulus
  add_npm_packages

  copy_templates

  add_whenever

  setup_git_repository
end
