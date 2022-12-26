def commit(message)
  git add: '.'
  git commit: "-m '#{message}'"
end

def copy_file(file_name, directory = '.')
  inside(directory) do
    puts "CURRENT PATH: #{File.dirname(__FILE__)}"
    file_path = File.expand_path("files/#{file_name}", File.dirname(__FILE__))
    run "cp #{file_path} ."
  end
end

def remove_file(file_name)
  run "rm #{file_name}"
end

git :init
commit 'Create Rails app'

copy_file '../files/README.md'
run %(sed -i '' "s/\\[APP NAME\\]/#{app_path.titleize}/" README.md)
commit 'Use markdown readme'

copy_file '../files/.rubocop.yml'
copy_file '../files/spec/.rubocop.yml', 'spec'
copy_file '../files/spec/factories/.rubocop.yml', 'spec/factories'
commit 'Add rubocop code style config'

run "sed -i '' '/^.*#/ d' Gemfile"
commit 'Remove Gemfile comments'

run "sed -i '' '/tzinfo-data/ d' Gemfile"
commit 'Remove unused gems'

gem 'rack-cors'
gem 'jsonapi-resources'
gem 'bcrypt'
gem 'doorkeeper'

commit 'Add gems for all environments'

gem_group :development do
  gem 'bullet'
  gem 'dotenv-rails'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'coderay'
  gem 'rubocop'
end

commit 'Add development gems'

gem_group :test do
  gem 'factory_bot_rails'
  gem 'rspec_junit_formatter'
end

commit 'Add test gems'

gem_group :production do
  gem 'rack-attack'
end
commit 'Add production gems'

run 'bundle install'
commit 'Bundle gems'

run 'bundle binstubs bundler --force'
run 'bundle binstubs rspec-core'
run 'rails generate rspec:install'
commit 'Set up RSpec'

run 'rails generate model user email:string:uniq password_digest:string'
copy_file '../files/db/seeds.rb', 'db'
copy_file '../files/app/models/user.rb', 'app/models'
copy_file '../files/spec/factories/user.rb', 'spec/factories'
remove_file 'spec/models/user_spec.rb'
commit 'Add user model'

run 'rails generate doorkeeper:install'
run 'rails generate doorkeeper:migration'

# TODO: match variable number of spaces
run "sed -i '' 's/t.references :application,    null: false/t.references :application/' db/migrate/*_create_doorkeeper_tables.rb"

copy_file '../files/config/initializers/doorkeeper.rb', 'config/initializers'
copy_file '../files/config/locales/doorkeeper.en.yml', 'config/locales'
copy_file '../files/spec/factories/access_token.rb', 'spec/factories'
commit 'Configure doorkeeper'

copy_file '../files/app/controllers/application_controller.rb', 'app/controllers'
copy_file '../files/app/resources/application_resource.rb', 'app/resources'
commit 'Expose Doorkeeper user to JR'

copy_file '../files/app/controllers/users_controller.rb', 'app/controllers'
copy_file '../files/app/resources/user_resource.rb', 'app/resources'
copy_file '../files/config/routes.rb', 'config'
copy_file '../files/spec/requests/register_spec.rb', 'spec/requests'
commit 'Expose user create endpoint'

copy_file '../files/spec/rails_helper.rb', 'spec'
copy_file '../files/spec/support/with_a_logged_in_user.rb', 'spec/support'
commit 'Add shared context for setting up a logged in user'

copy_file '../files/config/initializers/cors.rb', 'config/initializers'
commit 'Configure CORS'

copy_file '../files/bin/sample-data', 'bin'
commit 'Add sample data script'

copy_file '../files/.circleci/config.yml', '.circleci'
commit 'Configure CircleCI'

run 'rails db:create'
run 'rails db:migrate'
run 'rails db:seed'
commit 'Set up database'

# TODO: clean up gem file
# TODO: Ruby version in gemfile?
# TODO: better error output
