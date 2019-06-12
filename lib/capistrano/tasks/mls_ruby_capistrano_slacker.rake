namespace :mls_ruby_capistrano_slacker do
  desc 'Notify about Capistrano builds via slack'

  username = 'SlackSpeaker'

  task :notify_about_beginning do
    # next unless ENV['CI_PROJECT_ID']
    # next unless ENV['CI_PROJECT_URL']
    # next unless ENV['CI_JOB_TOKEN']

    require 'net/https'
    require 'uri'
    require 'json'

    puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [ℹ️] notify_about_beginning'

    on roles(:all) do |host|
      text = '_test_'

      puts "mls_ruby_capistrano_slacker_webhook_url:"
      puts fetch(:mls_ruby_capistrano_slacker_webhook_url)

      notifier = Slack::Notifier.new \
        fetch(:mls_ruby_capistrano_slacker_webhook_url),
        username: username

      # notifier.post icon_emoji: ':scream_cat:', text: """
      #   <!channel> #{ text }"""

      #
      # NOTE: getting random lorem picsum image
      #
      lorem_picsum_domain   = "https://picsum.photos"
      lorem_picsum_response = Net::HTTP.get_response(URI.parse( "#{ lorem_picsum_domain }/200" ))
      lorem_picsum_path     = lorem_picsum_response['location']

      gitlab_response = Net::HTTP.get_response(URI.parse("#{ ENV.fetch('CI_API_V4_URL') }/users?username=#{ ENV.fetch('GITLAB_USER_LOGIN') }"))

      a_ok_note = {
        fallback: "Everything looks peachy",
        text: "Everything looks peachy",
        author_name: ENV.fetch('GITLAB_USER_NAME'),
        author_link: "https://#{ URI.parse( ENV.fetch('CI_API_V4_URL') ).host }/users/#{ ENV.fetch('GITLAB_USER_LOGIN') }",
        author_ico: JSON.parse(gitlab_response.body).first['avatar_url'],
        color: "good",
        footer: '<https://github.com/MLSDev/mls_ruby_capistrano_slacker|mls_ruby_capistrano_slacker>',
        footer_ico: 'https://avatars2.githubusercontent.com/u/1436035?s=50&v=4',
        image_url: "#{ lorem_picsum_domain }/#{ lorem_picsum_path }",
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
            title: 'Hosts',
            value: release_roles(:all).map(&:hostname).join(", "),
            short: true
          }
        ]
      }

      notifier.post text: '', attachments: [a_ok_note]
    end

    # begin
    #   puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [ℹ️] Getting last tag'

    #   tags_uri = URI.parse(
    #     "#{ ENV['CI_API_V4_URL'] }/projects/#{ ENV['CI_PROJECT_ID'] }/repository/tags"
    #   )

    #   headers = {
    #     'Accept':        'application/json',
    #     'Content-Type':  'application/json',
    #     'PRIVATE-TOKEN': ENV['PRIVATE_TOKEN']
    #   }

    #   http = Net::HTTP.new(tags_uri.host, tags_uri.port)
    #   http.use_ssl = true

    #   request = Net::HTTP::Get.new(tags_uri.request_uri, headers)
    #   response = http.request(request)

    #   case response
    #   when Net::HTTPSuccess
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [✅] Tags'
    #   when Net::HTTPUnauthorized
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] Net::HTTPUnauthorized - have You missed PRIVATE_TOKEN configuration?'
    #     exit 1
    #   when Net::HTTPServerError
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] Net::HTTPServerError'
    #     exit 1
    #   else
    #     puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] #{ response }"
    #     exit 1
    #   end

    #   parsed_response = JSON.parse(response.body)

    #   last_tag = parsed_response.first.try(:[], 'name')
    #   if last_tag
    #     puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [ℹ️] We found that last tag is #{ last_tag }"
    #   else
    #     last_tag ||= 'production' # in case if there was no tags created yet
    #     puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [ℹ️] We didnt found last tag in your git repository. So, its supposed that You have #{ last_tag } branch that will be used as last save point."
    #     puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [ℹ️] Also, we will use #{ ENV['CI_COMMIT_REF_NAME'] } branch that supposed to be latest branch that is gonna be deployed"
    #   end

    #   compare_uri = URI.parse(
    #     "#{ ENV['CI_API_V4_URL'] }/projects/#{ ENV['CI_PROJECT_ID'] }/repository/compare?from=#{ last_tag }&to=#{ ENV['CI_COMMIT_REF_NAME'] }"
    #   )

    #   http = Net::HTTP.new(compare_uri.host, compare_uri.port).tap { |http| http.use_ssl = true }

    #   request = Net::HTTP::Get.new(compare_uri.request_uri, headers)
    #   response = http.request(request)

    #   case response
    #   when Net::HTTPSuccess
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [✅] Compare'
    #   when Net::HTTPUnauthorized
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] Net::HTTPUnauthorized - have You missed PRIVATE_TOKEN configuration?'
    #     exit 1
    #   when Net::HTTPServerError
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] Net::HTTPServerError'
    #     exit 1
    #   else
    #     puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] #{ response }"
    #     exit 1
    #   end

    #   parsed_response = JSON.parse(response.body)

    #   # commits key - should be array of hashes
    #   messages =  parsed_response.fetch('commits', []).map do |commit|
    #     "1. [[VIEW]](#{ ENV['CI_PROJECT_URL'] }/commit/#{ commit['id'] }) #{ commit['title'] } (#{ commit['author_name'] })\n"
    #   end

    #   release_description = messages.join

    #   puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [ℹ️] Release notes length is #{ release_description.size }"

    #   uri = URI.parse(
    #     "#{ ENV['CI_API_V4_URL'] }/projects/#{ ENV['CI_PROJECT_ID'] }/repository/tags"
    #   )

    #   headers = {
    #     'Accept':       'application/json',
    #     'Content-Type': 'application/json',
    #     'PRIVATE-TOKEN': ENV['PRIVATE_TOKEN']
    #   }

    #   body = {
    #     tag_name:            Time.now.strftime("%Y__%m__%d__%H_%M"),
    #     ref:                 ENV['CI_COMMIT_REF_NAME'],
    #     message:             'RELEASE 🎉🎉🎉',
    #     release_description: release_description
    #   }

    #   http = Net::HTTP.new(uri.host, uri.port)
    #   http.use_ssl = true
    #   request = Net::HTTP::Post.new(uri.request_uri, headers)
    #   request.body = body.to_json
    #   response = http.request(request)

    #   case response
    #   when Net::HTTPSuccess
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [✅] Create tag'
    #   when Net::HTTPUnauthorized
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] Net::HTTPUnauthorized - have You missed PRIVATE_TOKEN configuration?'
    #     exit 1
    #   when Net::HTTPServerError
    #     puts 'ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] Net::HTTPServerError'
    #     exit 1
    #   else
    #     puts "ⓂⓁⓈ-ⓉⒺⒸ [🛠] :: [🚨] #{ response }"
    #     exit 1
    #   end
    # rescue => e
    #   puts "An error happen while tagging. Plz double check if there was any misconfigurations."
    #   puts e.message
    # end
  end

  before 'deploy:starting', 'mls_ruby_capistrano_slacker:notify_about_beginning'
end

namespace :load do
  task :defaults do
    set :mls_ruby_capistrano_slacker_webhook_url, -> { fail ':slack_url is not set' }
  end
end
