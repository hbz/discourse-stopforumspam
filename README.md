# discourse-stopforumspam

The Stop Forum Spam plugin can help weed out human spammers who are able to bypass Discourse’s built-in spam tools (thanks to their awesome human powers). Right after a new user signs up on your 
forum (before they have time to post), this plugin will check the user's email address, forum username, and/or IP address (depending on your plugin settings) against 
the [Stop Forum Spam](https://www.stopforumspam.com) database. If the user is found in this database of known spammers, their user account will be immediately auto silenced in Discourse.

**Note:** If needed, you can unsilence the user in the **Users** &rarr; **Silenced** section of the Discourse Admin.

## Installation

Follow [these instructions](https://meta.discourse.org/t/install-plugins-in-discourse/19157) to install this plugin in your Discourse installation.

**Note:** This plugin's git clone url is [https://github.com/singerscreations/discourse-stopforumspam.git](https://github.com/singerscreations/discourse-stopforumspam.git).

## Configuration

After installing this plugin in Discourse, you'll be able to configure the following settings in the **Settings** &rarr; **Plugins** section of the Discourse Admin:

- **stopforumspam enabled:** Enable or disable the plugin
- **stopforumspam check email:** Checks the user's email address against the Stop Forum Spam database
- **stopforumspam check username:** Checks the user's username against the Stop Forum Spam database 
- **stopforumspam check ip:** Checks the user's IP address against the Stop Forum Spam database

**Note:** If you have more than one of these check settings enabled, the user will be deemed a spammer as soon as one of them is found in the Stop Forum Spam database.

## Issues

Please contact mike@singerscreations.com if you run into any issues or have a suggestion to improve this plugin. You can also post over in [this topic](https://meta.discourse.org/t/discourse-stop-forum-spam-plugin-auto-silence-spammers/121037) in the Discourse community forum.

## Authors

This plugin was created and is maintained by Mike Singer ([@msinger](https://meta.discourse.org/u/msinger)).