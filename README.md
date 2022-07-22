# Prest

[![Gem Version](https://badge.fury.io/rb/prest.svg)](https://badge.fury.io/rb/prest)
[![Ruby](https://github.com/gogrow-dev/prest/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/gogrow-dev/prest/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/f81b2e00be4d8eaa5e81/maintainability)](https://codeclimate.com/github/gogrow-dev/prest/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f81b2e00be4d8eaa5e81/test_coverage)](https://codeclimate.com/github/gogrow-dev/prest/test_coverage)

Programmaticcally communicate with any REST API.

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

# To pass headers to the request, pass them to the client constructor
Prest::Client.new('https://example.com/api', { headers: { 'Authorization' => 'Bearer Token xxxyyyzzz' } })
             .users
             .get

# To pass a body to the request, pass them to post/put/patch method as follows:
Prest::Client.new('https://example.com/api', { headers: { 'Authorization' => 'Bearer Token xxxyyyzzz' } })
             .users
             .post(body: { username: 'juan-apa' })
```

### Rails service-like approach

```ruby
# app/services/github.rb
class Github
  BASE_URL = 'https://api.github.com'

  def new
    Prest::Client.new(BASE_URL, { headers: headers })
  end

  private

  def headers
    {
      'access_token' => 'xxxyyyzzz'
    }
  end
end

# Then, you can use it like this anywhere in your app:

Github.new.users('juan-apa').pulls.get
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
