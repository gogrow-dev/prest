# Prest

[![Gem Version](https://badge.fury.io/rb/prest.svg)](https://badge.fury.io/rb/prest)
[![Ruby](https://github.com/gogrow-dev/prest/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/gogrow-dev/prest/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/f81b2e00be4d8eaa5e81/maintainability)](https://codeclimate.com/github/gogrow-dev/prest/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f81b2e00be4d8eaa5e81/test_coverage)](https://codeclimate.com/github/gogrow-dev/prest/test_coverage)

Programmatically communicate with any REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prest'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install prest

## Usage

```ruby
Prest::Client.new('https://example.com/api').users.get # instead of .get you can use .put .patch .post .delete
# This translates to making a GET https://example.com/api/users

Prest::Client.new('https://example.com/api').users(2).get
# This translates to making a GET https://example.com/api/users/2

Prest::Client.new('https://example.com/api').users(name: 'Juan', created_at: '2022-07-20').get
# This translates to making a GET https://example.com/api/users?name=Juan&created_at=2022-07-20

# You can also chain methods/fragments as many times as you want
Prest::Client.new('https://example.com/api').users(2).pulls(1).comments.get
# This translates to making a GET https://example.com/api/users/2/pulls/1/comments

# To make requests to url which have a dash in it, use a double __
Prest::Client.new('https://example.com/api').job__posts(1).get
# This translates to making a GET https://example.com/api/job-posts/1

# To pass headers to the request, pass them to the client constructor
Prest::Client.new('https://example.com/api', { headers: { 'Authorization' => 'Bearer Token xxxyyyzzz' } })
             .users
             .get

# To pass a body to the request, pass them to post/put/patch method as follows:
Prest::Client.new('https://example.com/api', { headers: { 'Authorization' => 'Bearer Token xxxyyyzzz' } })
             .users
             .post(body: { username: 'juan-apa' })
```

### Accessing the response

```ruby
response = Prest::Client.new('https://example.com/api').users.get

response[:users] # is equivalent to response.body[:users]
# You can access the body directly from the response object

response.successful? # is equivalent to response.status is between 200-299

response.status # returns the status code of the response
response.headers # returns the headers of the response
response.body # returns the body of the response
```

### Rails service-like approach

```ruby
# app/services/github.rb
class Github < Prest::Service
  private

  def base_uri
    'https://api.github.com'
  end

  def options
    {
      headers: {
        'access_token' => 'xxxyyyzzz'
      }
    }
  end
end

# Then, you can use it like this anywhere in your app:

Github.users('juan-apa').pulls.get
```

You can also define an initializer to pass values in runtime to your service:

```ruby
# app/services/github.rb
class Github < Prest::Service
  def initialize(organization)
    @organization = organization
  end

  private

  def base_uri
    'https://api.github.com'
  end

  def options
    {
      headers: {
        'access_token' => 'xxxyyyzzz',
        'org' => @organization
      }
    }
  end
end

# Then, you can use it like this anywhere in your app:

Github.new('gogrow-dev').users.get
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gogrow-dev/prest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/gogrow-dev/prest/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Prest project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/gogrow-dev/prest/blob/main/CODE_OF_CONDUCT.md).

## Credits

Prest is maintained by [GoGrow](https://gogrow.dev) with the help of our
[contributors](https://github.com/gogrow-dev/prest/contributors).

[<img src="https://user-images.githubusercontent.com/9309458/180014465-00477428-fd76-48f6-b984-5b401b8ce241.svg" height="50"/>](https://gogrow.dev)
