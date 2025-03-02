# frozen_string_literal: true

require_dependency 'discourse_event'

module DiscourseStopForumSpam

  def self.with_client
    StopForumSpam::Client.with_client() do |client|
      yield client
    end
  end

  def self.check_for_spam(user)
    return if user.blank?
	
	puts "[StopForumSpam] Checking '#{user.email}' in StopForumSpam..."
	
    DiscourseStopForumSpam.with_client do |client|
      reason = client.is_spammer(user)

	  if reason
	    puts "[StopForumSpam] #{user.email}: #{reason}"
	  	  
		UserSilencer.new(user, Discourse.system_user, reason: reason).silence
		DiscourseStopForumSpam.delete_user_field(user, 'stopforumspam_recheck')
      else
        puts "[StopForumSpam] No spam thresholds exceeded for '#{user.email}' in StopForumSpam."
        
        if SiteSetting.stopforumspam_recheck_users_after_hours > 0
          DiscourseStopForumSpam.set_user_field(user, 'stopforumspam_recheck', '')
        else
          DiscourseStopForumSpam.delete_user_field(user, 'stopforumspam_recheck')
	    end
      end
	end
  end
  
  def self.recheck_for_spam(user)
    return if user.blank?
	
	puts "[StopForumSpam] Rechecking '#{user.email}' in StopForumSpam..."
	
    DiscourseStopForumSpam.with_client do |client|
      reason = client.is_spammer(user)
	  
      if reason
		puts "[StopForumSpam] #{reason}"
		
		UserSilencer.new(user, Discourse.system_user, reason: reason).silence
	  end
	  
	  DiscourseStopForumSpam.delete_user_field(user, 'stopforumspam_recheck')
	end
  end
  
  def self.set_user_field(user, name, value)
	return if user.blank? || name.blank? || value.nil?
	
	if user.respond_to?(:upsert_custom_fields)
      user.upsert_custom_fields(name => value)
    else
      user.custom_fields.merge!(name => value)
      user.save_custom_fields
    end
  end
  
  def self.delete_user_field(user, name)
    return false if user.blank? || name.blank?
  
    user.custom_fields.delete(name)
    user.save_custom_fields
  end

end