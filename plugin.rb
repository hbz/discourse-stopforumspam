# name: discourse-stopforumspam
# about: Silences new users who are found in the StopForumSpam.com database of suspected spammers
# version: 0.0.1
# authors: Mike Singer
# site: https://github.com/singerscreations/discourse-stopforumspam

enabled_site_setting :stopforumspam_enabled

load File.expand_path('../lib/discourse_stopforumspam.rb', __FILE__)
load File.expand_path('../lib/stopforumspam.rb', __FILE__)

after_initialize do
  require_dependency File.expand_path('../jobs/check_user_for_spam.rb', __FILE__)

  on(:user_created) do |user|
    # DiscourseAkismet.move_to_state(post, 'new', params)
	# WebHook.enqueue_object_hooks(:user, user, event)
    # Jobs.enqueue(:check_akismet_post, post_id: post.id) if post.user.trust_level == 0
    puts "NEW USER CREATED --> #{user.email}"
	
	Jobs.enqueue(:check_user_for_spam, user_id: user.id)
  end
  
end