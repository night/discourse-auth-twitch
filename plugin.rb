# name: Twitch
# about: Authenticate to Discourse with Twitch
# version: 1.0.3
# author: Night (nightdev.com)

gem 'omniauth-twitch', '1.2.0'
gem 'omniauth-rails_csrf_protection', '1.0.2'

class TwitchAuthenticator < ::Auth::Authenticator

  CLIENT_ID = ENV["TWITCH_CLIENT_ID"]
  CLIENT_SECRET = ENV["TWITCH_CLIENT_SECRET"]

  def name
    'twitch'
  end

  def enabled?
    true
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new

    # grab the info we need from omni auth
    data = auth_token[:info]
    extra = auth_token[:extra]
    username = data["nickname"]
    name = data["name"]
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
     scope: 'user:read:email'
  end
end

auth_provider :pretty_name => 'Twitch',
    :title => 'Sign in with Twitch',
    :authenticator => TwitchAuthenticator.new,
    :icon => 'fab-twitch'

register_svg_icon "fab fa-twitch" if respond_to?(:register_svg_icon)

register_css <<CSS

.btn-social.twitch {
  background: #6441A5;
}

CSS
