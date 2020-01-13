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

def add_users
  # Install Devise
  generate "devise:install"
  generate "devise_invitable:install"

  # Install Pundit policies
  generate "pundit:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  # Create Devise User
  generate :devise, "User"
  generate :devise_invitable, "User"

  # add_active_admin

  generate "migration devise_changes_to_users"

  # Add additional user migrations
  devise_changes = Dir["db/migrate/**/*devise_changes_to_users.rb"].first
  insert_into_file devise_changes, after: "  def change\n" do
    <<-'RUBY'
    add_column :users, :display_name, :string
    add_column :users, :avatar_url, :string

    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    ## Lockable
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    ## Announcements
    add_column :users, :announcements_last_read_at, :datetime

    ## Admin
    add_column :users, :admin, :boolean, default: false

    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    RUBY
  end

  requirement = Gem::Requirement.new("> 6.0")
  rails_version = Gem::Version.new(Rails::VERSION::STRING)

  if requirement.satisfied_by? rails_version
    gsub_file "config/initializers/devise.rb",
      /  # config.secret_key = .+/,
      "  config.secret_key = Rails.application.credentials.secret_key_base"
  end
end

def copy_templates
  FileUtils.rm_rf(Dir['.db/*']) # clear the generated db dir
  directory "app", force: true
  directory "db", force: true
  directory "config", force: true
  directory "lib", force: true
  directory "spec", force: true
  directory "docker", force: true
  copy_file "Dockerfile", force: true
  copy_file "docker-compose.yml", force: true
  copy_file "docker-compose.dev.yml", force: true
  copy_file "docker-compose.prod.yml", force: true
  copy_file ".dockerignore", force: true
  copy_file "babel.config.js", force: true
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
  rails_command 'webpacker:install'
  gsub_file "config/environments/development.rb",
    /config.webpacker.check_yarn_integrity = true/,
    "config.webpacker.check_yarn_integrity = false"
end

def add_vuejs
  rails_command 'webpacker:install:vue'
end

def add_npm_packages
  run 'yarn add turbolinks tailwindcss vuex vue-router vuex-router-sync vue-meta vue-turbolinks axios core-js register-service-worker lodash date-fns feather-icons'
  run 'yarn add --dev @vue/cli-service @vue/cli-plugin-babel @vue/cli-plugin-eslint @vue/cli-plugin-unit-jest @vue/test-utils eslint babel-eslint prettier eslint-plugin-vue eslint-plugin-prettier purgecss-webpack-plugin sass sass-loader vue-template-compiler'
end

def add_jest
  insert_into_file "package.json", after: "  \"private\": true,\n" do
  <<-'RUBY'
  "scripts": {
    "test": "vue-cli-service test:unit",
    "lint": "vue-cli-service lint"
  },
  "gitHooks": {
    "pre-commit": "lint-staged"
  },
  "lint-staged": {
    "*.{js,vue}": [
      "vue-cli-service lint",
      "git add"
    ]
  },
  RUBY
  end
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"
end

def add_foreman
  copy_file "Procfile"
end

def add_gems
  gem 'redis'
  gem 'image_processing'
  gem "aws-sdk-s3", require: false
  gem 'pundit'
  gem 'enumerize'
  gem 'pagy'
  gem 'pg_search'
  gem 'devise'
  gem 'doorkeeper'
  gem 'devise_invitable'
  gem 'devise_masquerade'
  gem 'gravtastic'
  gem 'active_model_serializers'
  gem 'webpacker'
  gem 'sidekiq'
  gem 'foreman'
  gem 'omniauth-google-oauth2'
  gem 'omniauth-facebook'
  gem 'omniauth-twitter'
  gem 'omniauth-github'
  gem 'whenever', require: false
  gem 'friendly_id'
  gem 'sitemap_generator'
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'factory_bot_rails'
    gem 'faker'
  end
end

def add_announcements
  generate "model Announcement published_at:datetime announcement_type name description:text"
end

def add_notifications
  generate "model Notification recipient_id:integer actor_id:integer read_at:datetime action:string notifiable_id:integer notifiable_type:string"
end

def add_active_admin
  generate "active_admin:install User"
  gsub_file "config/initializers/active_admin.rb",
    /config.authentication_method = :authenticate_user!/,
    "config.authentication_method = :authenticate_admin_user!"
  gsub_file "config/initializers/active_admin.rb",
    /# config.logout_link_method = :get/,
    "config.logout_link_method = :delete"
  gsub_file "db/seeds.rb",
    /User.create!\(/,
    "User.create!(admin: true, "
  user_migration = Dir["db/migrate/**/*add_devise_to_users.rb"].first
  if user_migration
    File.delete(user_migration)
  end
end

def add_doorkeeper
  generate "doorkeeper:install"
  generate "doorkeeper:migration"
end

def add_multiple_authentication
    generate "model Service user:references provider uid access_token access_token_secret refresh_token expires_at:datetime auth:text"
    generate "model UserPreference user:references:unique data:jsonb"

    template = """
  if Rails.application.credentials.google_app_id.present? && Rails.application.credentials.google_app_secret.present?
    config.omniauth :google, Rails.application.credentials.google_app_id, Rails.application.credentials.google_app_secret
  end

  if Rails.application.credentials.facebook_app_id.present? && Rails.application.credentials.facebook_app_secret.present?
    config.omniauth :facebook, Rails.application.credentials.facebook_app_id, Rails.application.credentials.facebook_app_secret, scope: 'email,user_posts'
  end

  if Rails.application.credentials.twitter_app_id.present? && Rails.application.credentials.twitter_app_secret.present?
    config.omniauth :twitter, Rails.application.credentials.twitter_app_id, Rails.application.credentials.twitter_app_secret
  end

  if Rails.application.credentials.github_app_id.present? && Rails.application.credentials.github_app_secret.present?
    config.omniauth :github, Rails.application.credentials.github_app_id, Rails.application.credentials.github_app_secret
  end
    """.strip

    insert_into_file "config/initializers/devise.rb", "  " + template + "\n\n",
          before: "  # ==> Warden configuration"
end

def add_whenever
  run "wheneverize ."
end

def add_friendly_id
  generate "friendly_id"

  insert_into_file(
    Dir["db/migrate/**/*friendly_id_slugs.rb"].first,
    "[6.0]",
    after: "ActiveRecord::Migration"
  )
end

def stop_spring
  run "spring stop"
end

def add_sitemap
  rails_command "sitemap:install"
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
  add_users
  add_doorkeeper
  add_sidekiq
  add_foreman
  add_webpack
  add_vuejs
  add_npm_packages
  add_jest
  add_announcements
  add_notifications
  add_multiple_authentication
  add_friendly_id

  copy_templates

  add_whenever

  add_sitemap

  setup_git_repository
end
