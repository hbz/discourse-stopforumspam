# frozen_string_literal: true

require 'excon'
require 'nokogiri'

class StopForumSpam
    class Error < StandardError; end
  
    class Client
      API_URL = "http://api.stopforumspam.org/api"

      def initialize()
      end

      def self.with_client()
        client = self.new()
        yield client if block_given?
      end

      def check_email(email)
        check_spam("email", email)
      end
    
      def check_username(username)
        check_spam("username", username)
      end
    
      def check_ip(ip)
        check_spam("ip", ip)
      end

      def is_spammer(user)
        return nil if user.nil?
    
        if SiteSetting.stopforumspam_check_email
          result = check_email(user.email)
          return "Email '#{user.email}' appears #{result[:frequency]} time#{'s' unless result[:frequency] == 1} in StopForumSpam." if result[:appears]
        end
    
        if SiteSetting.stopforumspam_check_username
          result = check_username(user.username)
          return "Username '#{user.username}' appears #{result[:frequency]} time#{'s' unless result[:frequency] == 1} in StopForumSpam." if result[:appears]
        end
    
        if SiteSetting.stopforumspam_check_ip
          result = check_ip(user.ip_address)
          return "IP address '#{user.ip_address}' appears #{result[:frequency]} time#{'s' unless result[:frequency] == 1} in StopForumSpam." if result[:appears]
        end
    
        nil
      end
    
      private
    
      def check_spam(type, value)
        response = fetch_stopforumspam_data(type, value)
        return { appears: false, frequency: 0 } unless response

        puts "[StopForumSpam] #{Nokogiri::XML(response).to_xml(indent: 0).gsub(/>\s+</, '><').strip}"
    
        parsed_response = Nokogiri::XML(response)
        appears = parsed_response.at_xpath("//appears")&.text == "yes"
        frequency = parsed_response.at_xpath("//frequency")&.text.to_i
    
        min_entries = SiteSetting.stopforumspam_minimum_entries_found.to_i
    
        { appears: appears && (min_entries == 0 || frequency >= min_entries), frequency: frequency }
      end
    
      def fetch_stopforumspam_data(type, value)
        api_url = SiteSetting.stopforumspam_api_url.presence || "http://api.stopforumspam.org/api"
        uri = "#{api_url}?#{type}=#{URI.encode_www_form_component(value)}&xml"
        response = Excon.get(uri, headers: { "User-Agent" => "Discourse-StopForumSpam-Plugin" })

        response.status == 200 ? response.body : nil
      end

    end
end