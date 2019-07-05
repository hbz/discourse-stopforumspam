# name: discourse-stopforumspam
# about: Silences new users who are found in the StopForumSpam.com database of suspected spammers
# version: 1.0.1
# authors: Mike Singer
# url: https://github.com/singerscreations/discourse-stopforumspam

enabled_site_setting :stopforumspam_enabled

load File.expand_path('../lib/discourse_stopforumspam.rb', __FILE__)
load File.expand_path('../lib/stopforumspam.rb', __FILE__)

after_initialize do
  require_dependency File.expand_path('../jobs/check_user_for_spam.rb', __FILE__)
  require_dependency File.expand_path('../jobs/recheck_users_for_spam.rb', __FILE__)

  on(:user_created) do |user|
    Jobs.enqueue(:check_user_for_spam, user_id: user.id)
  end
  
end