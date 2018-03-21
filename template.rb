 # http://guides.rubyonrails.org/rails_application_templates.html
 # overwrite source_paths to allow thor methods like copy_file 
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'devise', '~> 4.3.0'
  gem 'foreman', '~> 0.84.0'
  gem 'redis', '3.3.3'
  gem 'sidekiq', '~> 5.0'
  gem 'simple_line_icons-rails', git: "https://github.com/cmm21/rails-simple-line-icons.git"
  gem 'webpacker', '~> 3.0'
end

def copy_template_files
  directory "app", force: true
  directory "config", force: true
end

def config_users
  generate "devise:install"

  generate "devise:views"

  # config devise mailer
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'welcome#index'"

  generate :devise, "User", 
           "username"
  
  requirement = Gem::Requirement.new("> 5.1")
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
end

def config_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"
end

def config_foreman
  copy_file "Procfile"
end

def config_webpack
  rails_command 'webpacker:install'
end

# Build Rails application
add_gems

after_bundle do
  # run configs
  config_users
  config_sidekiq
  config_foreman
  config_webpack
  
  copy_template_files
  
  # run migrations
  rails_command "db:create"
  rails_command "db:migrate"
end