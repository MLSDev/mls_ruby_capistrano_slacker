# mls_ruby_capistrano_slacker
Capistrano and GitLab to Slack integration.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mls_ruby_capistrano_slacker', tag: 'vX.X.X', github: 'MLSDev/mls_ruby_capistrano_slacker'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install mls_ruby_capistrano_slacker
```

Update `Capistrano`

```ruby
require 'capistrano/mls_ruby_capistrano_slacker'
```

Add variable to your stage

```ruby
set :mls_ruby_capistrano_slacker_webhook_url, ENV.fetch('CAPISTANO_SLACKER_WEBHOOK_URL')
```

Also, if you want to publish release description to your Slack - just set following variable in your deploy configs

```ruby
set :mls_ruby_capistrano_slacker_post_release_description, true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
