# apiup

Creates a new Rails API pre-configured for JSON API and OAuth 2 authentication:

- Configures [JSONAPI::Resources](http://jsonapi-resources.com/) for [JSON API](http://jsonapi.org/)
- Configures [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) for OAuth 2 authentication
- Creates a User model with [`has_secure_password`](https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password) for password storage
- Sets up a `POST /users` endpoint for registration
- Configures [factory_bot](https://github.com/thoughtbot/factory_bot) factories for User and access tokens to make request specs easy
- Passes the `current_user` to JSONAPI::Resources

Also includes the following setup:

- Enables Rails API mode
- Removes Action Cable, Active Storage, Bootsnap, JBuilder, Spring, and Turbolinks
- Uses Postgres instead of SQLite
- Uses [RSpec](http://rspec.info/) instead of Minitest
- Uses [pry](https://github.com/pry/pry) instead of byebug
- Disables authenticity token
- Enables [CORS](https://github.com/cyu/rack-cors)
- Configures a CircleCI configuration file for continuous integration
- Adds:
  - [Bullet](https://github.com/flyerhzm/bullet)
  - [Dotenv](https://github.com/bkeepers/dotenv)
  - [Faker](https://github.com/stympy/faker)
  - [Rack-Attack](https://github.com/kickstarter/rack-attack)

To learn more, see ["Authorizing jsonapi_resources"](https://www.bignerdranch.com/blog/authorizing-jsonapi-resources-part-1-visibility/).

## Installation

Download the repo, then run `bin/apiup NEW-APP-NAME`.

To be able to run `apiup` from anywhere, add the repo's `bin` directory to your `PATH`.

## Usage

You can set up your API using typical Rails, JSONAPI::Resources, and Doorkeeper features. Here are some common first steps.

### Creating a model

Say you're creating a project management app. Start with generating a Project model:

```sh
$ rails generate model project name:string
```

You can add `field:type` pairs to automatically add them:

The list of available types is at <https://api.rubyonrails.org/v5.2.1/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_column>

If you want a record to be connected to another record, add the name of that model, with the `:references` field type. For example, to associate the record with a user, add `user:references`.

### Creating a resource

Resources control the public view of your model that is exposed. This is the main class you'll modify.

```sh
$ rails generate jsonapi:resource project
```

Then update the resource to inherit from `ApplicationResource`.

Add each attribute you want publicly visible. Add each `has_many` or `has_one` relationship you want to expose as well:

```ruby
class ProjectResource < ApplicationResource
  attribute :name
  has_many :stories
end
```

If you want to automatically assign a created record to the logged-in user, pass a blog to `before_create` (note that `current_user` will only be available if you inherit from `ApplicationResource`):

```ruby
before_create do
  _model.user = current_user
end
```

You may also want to prevent manually assigning the `user` by removing it from the list of creatable and updatable fields:

```ruby
def self.creatable_fields(context)
  super - [:user]
end

def self.updatable_fields(context)
  super - [:user]
end
```

If you want to limit the records shown, override `self.records`. For example, to return only records belonging to the current user:

```ruby
def self.records(options = {})
  user = current_user(options)
  user.projects
end
```

(Note that the class method `current_user` requires `options` to be passed to it, whereas the instance method `current_user` does not.)

### Creating a controller

To create a controller for a JSON:API resource:

```sh
$ rails generate jsonapi:controller projects
```

Update the controller to inherit from `ApplicationController`. This disables CSRF and makes the `current_user` available to the resources.

If you don't want a controller to be available to users who aren't logged in, add:

```ruby
before_action :doorkeeper_authorize!
```

You shouldn't need to customize anything else in the controller.

### Adding routes

Add the following to `routes.rb`:

```ruby
jsonapi_resources :projects
```

Not only will `jsonapi_resources` add the routes for the projects model, it will also add nested routes for any models related to projects.

## Thanks

Based on [this blog post](http://iamvery.com/2015/02/17/rails-new-for-you.html) by [iamvery](https://github.com/iamvery).

## License

Apache-2.0. See `License.txt` for details.
