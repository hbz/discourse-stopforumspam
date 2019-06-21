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
	
    DiscourseStopForumSpam.with_client do |client|
	  if client.is_spammer(user)
		UserSilencer.new(user, Discourse.system_user, reason: I18n.t("stopforumspam.silenced_reason")).silence
	  end
	end
  end

end