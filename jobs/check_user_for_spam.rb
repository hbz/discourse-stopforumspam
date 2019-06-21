# frozen_string_literal: true

module Jobs
  class CheckUserForSpam < Jobs::Base

    def execute(args)
      raise Discourse::InvalidParameters.new(:user_id) unless args[:user_id].present?
      return unless SiteSetting.stopforumspam_enabled?
	
	  user = User.where(id: args[:user_id]).first
	  DiscourseStopForumSpam.check_for_spam(user)
    end
  end
end