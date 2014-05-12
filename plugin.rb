# name: Twitch
# about: Authenticate to Discourse with Twitch
# version: 1.0.0
# author: Night (nightdev.com)

gem 'omniauth-twitch', '0.1.2'

class TwitchAuthenticator < ::Auth::Authenticator

  CLIENT_ID = ENV["twitch_client_id"]
  CLIENT_SECRET = ENV["twitch_client_secret"]

  def name
    'twitch'
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new

    # grab the info we need from omni auth
    data = auth_token[:info]
    extra = auth_token[:extra]
    username = data["name"]
    name = extra["display_name"]
    email = data["email"]
    twitch_uid = auth_token["uid"]

    # plugin specific data storage
    current_info = ::PluginStore.get("twitch", "twitch_uid_#{twitch_uid}")

    result.user =
      if current_info
        User.where(id: current_info[:user_id]).first
      end

    result.username = username
    result.name = name
    result.email = email
    result.extra_data = { twitch_uid: twitch_uid }

    result
  end

  def after_create_account(user, auth)
    data = auth[:extra_data]
    ::PluginStore.set("twitch", "twitch_uid_#{data[:twitch_uid]}", {user_id: user.id })
  end

  def register_middleware(omniauth)
    omniauth.provider :twitch,
     CLIENT_ID,
     CLIENT_SECRET,
     scope: 'user_read'
  end
end

auth_provider :title => 'with Twitch',
    :message => 'Log in with Twitch (Make sure pop up blockers are not enabled).',
    :frame_width => 920,
    :frame_height => 800,
    :authenticator => TwitchAuthenticator.new

register_css <<CSS

.btn-social.twitch {
  background: #6441A5;
}

.btn-social.twitch:before {
  content: " ";
}

CSS