namespace :mls_ruby_capistrano_slacker do
  desc 'Notify about Capistrano builds via Slack'

  require 'net/https'
  require 'uri'
  require 'json'

  time_now = Time.now.to_i

  #
  # BEGINNING
  #
  task :notify_about_beginning do
    puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] notify_about_beginning'

    on roles(:all) do |host|
      notifier = Slack::Notifier.new \
        fetch(:mls_ruby_capistrano_slacker_webhook_url),
        username: 'CapistranoSlacker',
        icon_emoji: ':ghost:'

      #
      # NOTE: getting random lorem picsum image
      #
      info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] get https://picsum.photos random url'
      begin
        lorem_picsum_domain   = "https://picsum.photos"
        lorem_picsum_response = Net::HTTP.get_response(URI.parse( "#{ lorem_picsum_domain }/200" ))
        lorem_picsum_path     = lorem_picsum_response['location']
        image_url             = "#{ lorem_picsum_domain }/#{ lorem_picsum_path }"
        info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [✅️] lorem pixum random url'
      rescue => e
        image_url             = nil
        info "ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [🚨] #{ e.message }"
      end

      #
      # NOTE: response from GitLab
      #
      info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] get GitLab user avatar'
      begin
        gitlab_response = Net::HTTP.get_response(URI.parse("#{ ENV.fetch('CI_API_V4_URL') }/users?username=#{ ENV.fetch('GITLAB_USER_LOGIN') }"))
        author_icon = JSON.parse(gitlab_response.body).first['avatar_url']
        info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [✅️] got link'
      rescue => e
        author_icon = nil
        info "ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [🚨] #{ e.message }"
      end

      notifier.post text: '', attachments: [
        {
          color: 'warning',
          fallback: 'New deploy has began',
          text: '_New deploy has began_',
          author_name: ENV.fetch('GITLAB_USER_NAME'),
          author_link: "https://#{ URI.parse( ENV.fetch('CI_API_V4_URL') ).host }/users/#{ ENV.fetch('GITLAB_USER_LOGIN') }",
          author_icon: author_icon,
          image_url: image_url,
          fields: [
            {
              title: 'Job',
              value: "<#{ ENV.fetch('CI_JOB_URL') }| #{ ENV.fetch('CI_JOB_STAGE') } >",
              short: true
            },
            {
              title: 'Pipeline',
              value: "<#{ ENV.fetch('CI_PIPELINE_URL') }| #{ ENV.fetch('CI_PIPELINE_ID') } via #{ ENV.fetch('CI_PIPELINE_SOURCE') } >",
              short: true
            },
            {
              title: 'Branch',
              value: "<#{ ENV.fetch('CI_PROJECT_URL') }/tree/#{ ENV.fetch('CI_COMMIT_REF_NAME') }|#{ ENV.fetch('CI_COMMIT_REF_NAME') }>",
              short: true
            },
            {
              title: 'Commit',
              value: "<#{ ENV.fetch('CI_PROJECT_URL') }/commits/#{ ENV.fetch('CI_COMMIT_SHA') }|#{ ENV.fetch('CI_COMMIT_TITLE') }>",
              short: true
            },
            {
              title: 'Hosts',
              value: release_roles(:all).map(&:hostname).join(', '),
              short: true
            },
          ],
          footer: '<https://github.com/MLSDev/mls_ruby_capistrano_slacker|mls_ruby_capistrano_slacker>',
          footer_ico: 'https://avatars2.githubusercontent.com/u/1436035?s=50&v=4',
          ts: time_now
        }
      ]
    end
  end

  #
  # FAILED
  #
  task :notify_failed do
    puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] notify_failed'

    on roles(:all) do |host|
      notifier = Slack::Notifier.new \
        fetch(:mls_ruby_capistrano_slacker_webhook_url),
        username: 'CapistranoSlacker',
        icon_emoji: ':ghost:'

      #
      # NOTE: response from GitLab
      #
      info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] get GitLab user avatar'
      begin
        gitlab_response = Net::HTTP.get_response(URI.parse("#{ ENV.fetch('CI_API_V4_URL') }/users?username=#{ ENV.fetch('GITLAB_USER_LOGIN') }"))
        author_icon = JSON.parse(gitlab_response.body).first['avatar_url']
        info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [✅️] got link'
      rescue => e
        author_icon = nil
        info "ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [🚨] #{ e.message }"
      end

      notifier.post text: '', attachments: [
        {
          color: 'danger',
          fallback: 'Deploy has failed',
          text: '_Deploy has failed_',
          author_name: ENV.fetch('GITLAB_USER_NAME'),
          author_link: "https://#{ URI.parse( ENV.fetch('CI_API_V4_URL') ).host }/users/#{ ENV.fetch('GITLAB_USER_LOGIN') }",
          author_icon: author_icon,
          fields: [
            {
              title: 'Job',
              value: "<#{ ENV.fetch('CI_JOB_URL') }| #{ ENV.fetch('CI_JOB_STAGE') } >",
              short: true
            },
            {
              title: 'Pipeline',
              value: "<#{ ENV.fetch('CI_PIPELINE_URL') }| #{ ENV.fetch('CI_PIPELINE_ID') } via #{ ENV.fetch('CI_PIPELINE_SOURCE') } >",
              short: true
            },
            {
              title: 'Branch',
              value: "<#{ ENV.fetch('CI_PROJECT_URL') }/tree/#{ ENV.fetch('CI_COMMIT_REF_NAME') }|#{ ENV.fetch('CI_COMMIT_REF_NAME') }>",
              short: true
            },
            {
              title: 'Commit',
              value: "<#{ ENV.fetch('CI_PROJECT_URL') }/commits/#{ ENV.fetch('CI_COMMIT_SHA') }|#{ ENV.fetch('CI_COMMIT_TITLE') }>",
              short: true
            },
            {
              title: 'Hosts',
              value: release_roles(:all).map(&:hostname).join(', '),
              short: true
            },
          ],
          footer: '<https://github.com/MLSDev/mls_ruby_capistrano_slacker|mls_ruby_capistrano_slacker>',
          footer_ico: 'https://avatars2.githubusercontent.com/u/1436035?s=50&v=4',
          ts: time_now
        }
      ]
    end
  end

  #
  # FINISHED
  #
  task :notify_finished do
    puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] notify_finished'

    on roles(:all) do |host|
      notifier = Slack::Notifier.new \
        fetch(:mls_ruby_capistrano_slacker_webhook_url),
        username: 'CapistranoSlacker',
        icon_emoji: ':ghost:'

      #
      # NOTE: response from GitLab
      #
      info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [ℹ️] get GitLab user avatar'
      begin
        gitlab_response = Net::HTTP.get_response(URI.parse("#{ ENV.fetch('CI_API_V4_URL') }/users?username=#{ ENV.fetch('GITLAB_USER_LOGIN') }"))
        author_icon = JSON.parse(gitlab_response.body).first['avatar_url']
        info 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [✅️] got link'
      rescue => e
        author_icon = nil
        info "ⓂⓁⓈ-ⓉⒺⒸ [🛠] [mls_ruby_capistrano_slacker] :: [🚨] #{ e.message }"
      end

      notifier.post text: '', attachments: [
        {
          color: 'good',
          fallback: 'Deploy has finished',
          text: '_Deploy has finished_',
          author_name: ENV.fetch('GITLAB_USER_NAME'),
          author_link: "https://#{ URI.parse( ENV.fetch('CI_API_V4_URL') ).host }/users/#{ ENV.fetch('GITLAB_USER_LOGIN') }",
          author_icon: author_icon,
          fields: [
            {
              title: 'Job',
              value: "<#{ ENV.fetch('CI_JOB_URL') }| #{ ENV.fetch('CI_JOB_STAGE') } >",
              short: true
            },
            {
              title: 'Pipeline',
              value: "<#{ ENV.fetch('CI_PIPELINE_URL') }| #{ ENV.fetch('CI_PIPELINE_ID') } via #{ ENV.fetch('CI_PIPELINE_SOURCE') } >",
              short: true
            },
            {
              title: 'Branch',
              value: "<#{ ENV.fetch('CI_PROJECT_URL') }/tree/#{ ENV.fetch('CI_COMMIT_REF_NAME') }|#{ ENV.fetch('CI_COMMIT_REF_NAME') }>",
              short: true
            },
            {
              title: 'Commit',
              value: "<#{ ENV.fetch('CI_PROJECT_URL') }/commits/#{ ENV.fetch('CI_COMMIT_SHA') }|#{ ENV.fetch('CI_COMMIT_TITLE') }>",
              short: true
            },
            {
              title: 'Hosts',
              value: release_roles(:all).map(&:hostname).join(', '),
              short: true
            },
          ],
          footer: '<https://github.com/MLSDev/mls_ruby_capistrano_slacker|mls_ruby_capistrano_slacker>',
          footer_ico: 'https://avatars2.githubusercontent.com/u/1436035?s=50&v=4',
          ts: time_now
        }
      ]
    end
  end

  before 'deploy:starting', 'mls_ruby_capistrano_slacker:notify_about_beginning'
  after  'deploy:failed',   'mls_ruby_capistrano_slacker:notify_failed'
  after  'deploy:finished', 'mls_ruby_capistrano_slacker:notify_finished'
end

namespace :load do
  task :defaults do
    set :mls_ruby_capistrano_slacker_webhook_url, -> { fail ':mls_ruby_capistrano_slacker_webhook_url is not set' }
  end
end
