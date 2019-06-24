# frozen_string_literal: true

module Jobs
  class RecheckUsersForSpam < ::Jobs::Scheduled
    every 10.minutes

    def execute(args)
      return unless SiteSetting.stopforumspam_enabled?
	  return unless SiteSetting.stopforumspam_recheck_users_after_hours > 0
	  
      User.joins("LEFT JOIN user_custom_fields ON users.id = user_id AND user_custom_fields.name = 'stopforumspam_recheck'")
	    .where.not(user_custom_fields: { value: nil })
		.where('users.created_at < ?', SiteSetting.stopforumspam_recheck_users_after_hours.hours.ago)
        .find_each do |user|
		
		DiscourseStopForumSpam.recheck_for_spam(user)
	  end
    end
  end
end