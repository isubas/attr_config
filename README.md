# Attr Config

It is a gem that allows you to easily management configurations at the class and instance level. Inspired by ActiveSupport class_attribute.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attr_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_config

## Usage

```ruby
class Provider
  include AttrConfig::Configurable

  # basic configurations
  attr_config :default_currency
  attr_config :lang
  attr_config :name, writable: { instance: false, class: false }
  attr_config :refresh_time, default: 0
  attr_config :store_type, default: '3d_pay_hosting'
  attr_config :transaction_type, default: 'Auth'
  attr_config :encoding, default: 'utf-8'

  # urls configurations
  attr_config :callback_url
  attr_config :fail_url
  attr_config :success_url
  attr_config :production_url
  attr_config :test_url

  # credentials configurations
  # NOTE: client_id and store_key cannot be read or written via instance
  attr_config :client_id, writable: { instance: false }, readable: { instance: false }
  attr_config :store_key, writable: { instance: false }, readable: { instance: false }
end

class Bank < Provider
  # specific configurations
  attr_config :base_schema
  attr_config :product_schema
  attr_config :invoice_schema

  # overwrite configurations
  attr_config :callback_url,   default: 'http://localhost/callback'
  attr_config :fail_url,       default: 'http://localhost/fail'
  attr_config :success_url,    default: 'http://localhost/success'
  attr_config :production_url, default: 'http://localhost/production'
  attr_config :test_url,       default: 'http://localhost/test'

  # configure example
  configure do |config|
    config.name             = 'Bank Name'
    config.test_url         = 'https://test.example.com'
  end

  # or
  self.default_currency = 'TL'
  self.lang = 'tr'
end

puts Provider.default_currency # nil
puts Provider.store_type # 3d_pay_hosting
puts Provider.callback_url # nil

puts Bank.store_type # 3d_pay_hosting
puts Bank.callback_url # http://localhost/callback

provider = Provider.new

puts provider.default_currency # nil
puts provider.lang # nil

provider.lang = 'en'
puts provider.lang # en
puts Provider.lang # nil

Provider.configure do |config|
  config.lang = 'tr'
  config.default_currency = 'USD'
end

puts Provider.default_currency # USD

provider_instance = Provider.new
puts provider_instance.default_currency # USD
provider_instance.default_currency = 'TL'
puts provider_instance.default_currency  # TL
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/isubas/attr_config. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the AttrConfig project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/isubas/attr_config/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
