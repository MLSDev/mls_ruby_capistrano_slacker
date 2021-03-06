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

Update `Capfile`

```ruby
require 'capistrano/mls_ruby_capistrano_slacker'
```

### mls_ruby_capistrano_slacker_webhook_url

Add variable to your stage

```ruby
set :mls_ruby_capistrano_slacker_webhook_url, ENV.fetch('CAPISTANO_SLACKER_WEBHOOK_URL')

set :mls_ruby_capistrano_slacker_display_display_random_picture, true # Default value false

set :mls_ruby_capistrano_slacker_notify_about_beginning, true # Default value false
```

### mls_ruby_gitlab_private_token

And don't forget to set `mls_ruby_gitlab_private_token`. You can generate it using this [guide](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token).
We prefere to set env variables via [UI](https://docs.gitlab.com/ee/ci/variables/#via-the-ui).

```ruby
set :mls_ruby_gitlab_private_token, ENV.fetch('GITLAB__PRIVATE_TOKEN')
```

### mls_ruby_capistrano_slacker_post_release_description

Also, if you want to publish release description to your Slack - just set following variable in your deploy configs

```ruby
set :mls_ruby_capistrano_slacker_post_release_description, true
```

### Ability to skip it

If You really need to have this gem inside your project, and dont want to see messages from that, You can add following key to `deploy.rb` or deploy configs:

```ruby
set :mls_ruby_capistrano_slacker_skip, true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
