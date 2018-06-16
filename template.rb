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

def add_gems
  gem 'pundit'
  gem 'enumerize'
  gem 'kaminari'
  gem 'pg_search'
  gem 'administrate', '~> 0.10.0'
  gem 'devise', '~> 4.4.3'
  gem 'devise_invitable', '~> 1.7.0'
  gem 'devise_masquerade', '~> 0.6.0'
  gem 'gravtastic'
  gem 'mini_magick', '~> 4.8'
  gem 'webpacker', '~> 3.4'
  gem 'sidekiq', '~> 5.0'
  gem 'foreman', '~> 0.84.0'
  gem 'omniauth-google-oauth2', '~> 0.5.3'
  gem 'omniauth-facebook', '~> 4.0'
  gem 'omniauth-twitter', '~> 1.4'
  gem 'omniauth-github', '~> 1.3'
  gem 'whenever', require: false
  gem 'friendly_id', '~> 5.1.0'
  gem 'sitemap_generator', '~> 6.0', '>= 6.0.1'
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'factory_bot_rails'
    gem 'faker'
  end
end

def set_application_config
  application do
  <<-'RUBY'
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
    end
  RUBY
  end
end

def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.parent_name"

  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
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

def setup_kaminari
  generate "kaminari:config"
end

def add_storage
  rails_command "active_storage:install"
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

  generate "migration devise_changes_to_users"

  # Add additional user migrations
  devise_changes = Dir["db/migrate/**/*devise_changes_to_users.rb"].first
  insert_into_file devise_changes, after: "  def change\n" do
    <<-'RUBY'
    add_column :users, :name, :string, null: false, default: ""

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

    ## Remove Trackable
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip

    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    RUBY
  end

  requirement = Gem::Requirement.new("> 5.2")
  rails_version = Gem::Version.new(Rails::VERSION::STRING)

  if requirement.satisfied_by? rails_version
    gsub_file "config/initializers/devise.rb",
      /  # config.secret_key = .+/,
      "  config.secret_key = Rails.application.credentials.secret_key_base"
  end
end

def copy_templates
  directory "app", force: true
  directory "config", force: true
  directory "lib", force: true
  directory "spec", force: true
  copy_file ".babelrc", force: true
  copy_file ".eslintrc.js", force: true
  copy_file ".prettierrc", force: true
  copy_file ".gitignore", force: true
  copy_file ".eslintignore", force: true
  copy_file ".editorconfig", force: true
end

def add_webpack
  rails_command 'webpacker:install'
end

def add_vuejs
  rails_command 'webpacker:install:vue'
end

def add_npm_packages
  run 'yarn add rails-ujs turbolinks activestorage actioncable tailwindcss glhd-tailwindcss-transitions vuex vue-router vuex-router-sync vue-meta vue-turbolinks axios babel-polyfill lodash date-fns feather-icons'
  run 'yarn add --dev babel-preset-es2015 eslint babel-eslint jest babel-jest vue-jest jest-serializer-vue @vue/test-utils prettier prettier-eslint eslint-loader eslint-config-prettier eslint-plugin-import eslint-plugin-node eslint-plugin-prettier eslint-plugin-promise eslint-plugin-vue purgecss-webpack-plugin@0.23.0 husky lint-staged'
end

def add_jest
  insert_into_file "package.json", after: "  \"private\": true,\n" do
  <<-'RUBY'
  "scripts": {
    "unit": "jest --config spec/javascript/jest.conf.js --coverage",
    "test": "npm run unit",
    "lint": "eslint --fix --ext .js,.vue app/javascript spec/javascript",
    "precommit": "lint-staged"
  },
  "lint-staged": {
    "*.{js,vue}": [
      "npm run lint",
      "git add"
    ]
  },
  "engines": {
    "node": ">= 6.0.0",
    "npm": ">= 3.0.0"
  },
  "browserslist": [
    "last 2 versions",
    "> 1%",
    "not ie <= 10"
  ],
  RUBY
  end
end

def add_tailwind
  run './node_modules/.bin/tailwind init app/javascript/styles/tailwind.js'
  insert_into_file ".postcssrc.yml",
    "  tailwindcss: './app/javascript/styles/tailwind.js'",
    after: "postcss-cssnext: {}\n"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"
end

def add_foreman
  copy_file "Procfile"
end

def add_announcements
  generate "model Announcement published_at:datetime announcement_type name description:text"
end

def add_notifications
  generate "model Notification recipient_id:integer actor_id:integer read_at:datetime action:string notifiable_id:integer notifiable_type:string"
end

def add_administrate
  generate "administrate:install"

  gsub_file "app/dashboards/announcement_dashboard.rb",
    /announcement_type: Field::String/,
    "announcement_type: Field::Select.with_options(collection: Announcement::TYPES)"

  gsub_file "app/controllers/admin/application_controller.rb",
    /# TODO Add authentication logic here\./,
    "redirect_to '/', alert: 'Not authorized.' unless user_signed_in? && current_user.admin?"

  directory "dashboards", "app/dashboards", force: true
end

def add_multiple_authentication
    generate "model Service user:references provider uid access_token access_token_secret refresh_token expires_at:datetime auth:text"

    template = """
  if Rails.application.secrets.google_app_id.present? && Rails.application.secrets.google_app_secret.present?
    config.omniauth :google, Rails.application.secrets.google_app_id, Rails.application.secrets.google_app_secret
  end

  if Rails.application.secrets.facebook_app_id.present? && Rails.application.secrets.facebook_app_secret.present?
    config.omniauth :facebook, Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, scope: 'email,user_posts'
  end

  if Rails.application.secrets.twitter_app_id.present? && Rails.application.secrets.twitter_app_secret.present?
    config.omniauth :twitter, Rails.application.secrets.twitter_app_id, Rails.application.secrets.twitter_app_secret
  end

  if Rails.application.secrets.github_app_id.present? && Rails.application.secrets.github_app_secret.present?
    config.omniauth :github, Rails.application.secrets.github_app_id, Rails.application.secrets.github_app_secret
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
    "[5.2]",
    after: "ActiveRecord::Migration"
  )
end

def stop_spring
  run "spring stop"
end

def add_sitemap
  rails_command "sitemap:install"
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
  setup_kaminari
  add_storage
  add_users
  add_sidekiq
  add_foreman
  add_webpack
  add_vuejs
  add_npm_packages
  add_tailwind
  add_jest
  add_announcements
  add_notifications
  add_multiple_authentication
  add_friendly_id

  copy_templates

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  # Migrations must be done before this
  add_administrate

  add_whenever

  add_sitemap


  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
