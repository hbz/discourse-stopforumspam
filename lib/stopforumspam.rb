# frozen_string_literal: true

require 'excon'

class StopForumSpam
  class Error < StandardError; end

  class Client
    PLUGIN_NAME = 'discourse-stopforumspam'.freeze
	API_URL = 'http://api.stopforumspam.org/api'.freeze
	RESPONSE_APPEARS = '<appears>yes</appears>'.freeze

    def initialize()
    end

    def self.with_client()
      client = self.new()
      yield client if block_given?
    end

    def is_spammer(user)
      (SiteSetting.stopforumspam_check_email && check_email(user.email)) || (SiteSetting.stopforumspam_check_username && check_username(user.username)) || (SiteSetting.stopforumspam_check_ip && check_ip(user.ip_address)) 
    end
	
	def check_email(email)
	  response = post("#{API_URL}?email=#{email}")
      response_body = response.body
	  response_body.include? RESPONSE_APPEARS
	end
	
	def check_username(username)
	  response = post("#{API_URL}?username=#{username}")
      response_body = response.body
	  response_body.include? RESPONSE_APPEARS
	end
	
	def check_ip(ip)
	  response = post("#{API_URL}?ip=#{ip}")
      response_body = response.body
	  response_body.include? RESPONSE_APPEARS
	end	

    def self.user_agent_string
      @user_agent_string ||= begin
        plugin_version = Discourse.plugins.find do |plugin|
          plugin.name == PLUGIN_NAME
        end.metadata.version

        "Discourse/#{Discourse::VERSION::STRING} | #{PLUGIN_NAME}/#{plugin_version}"
      end
    end

    def post(url)
      response = Excon.post(url,
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent' => self.class.user_agent_string
        }
      )

      if response.status != 200
        raise StopForumSpam::Error.new(response.status_line)
      end

      response
    end
  end
  
end