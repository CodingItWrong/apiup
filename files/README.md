# [APP NAME]

This is a short description of your app.

## Getting Started

### Requirements

1. Ruby
1. PostgreSQL (e.g. [Postgres.app][postgres-app])

### Setup

```sh
$ bin/bootstrap
```

### Development

To generate models, resources, and controllers:

```bash
$ rails generate model widget [fields]
$ rails generate jsonapi:resource widget
$ rails generate jsonapi:controller widget
```

### Testing

```sh
$ bin/rspec
```

In request tests, you can use the user and access token factories to create test data to access protected resources:

```ruby
user = FactoryBot.create(:user)
token = FactoryBot.create(:access_token, resource_owner_id: user.id).token
headers = {
  'Authorization' => "Bearer #{token}",
  'Content-Type' => 'application/vnd.api+json',
}

# assuming you have a Widget model that belongs to a User
FactoryBot.create(:widget, user: user)

get '/widgets', headers: headers
```

### Running

```sh
$ rails server
```

[postgres-app]: http://postgresapp.com
