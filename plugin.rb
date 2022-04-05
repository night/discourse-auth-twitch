# name: Twitch
# about: Authenticate to Discourse with Twitch
# version: 1.0.2
# author: Night (nightdev.com)

gem 'omniauth-twitch', '1.1.0'

enabled_site_setting :sign_in_with_twitch_enabled

class TwitchAuthenticator < ::Auth::ManagedAuthenticator

  def name
    'twitch'
  end

  def can_revoke?
    true
  end

  def can_connect_existing_user?
    true
  end

  def enabled?
    SiteSetting.sign_in_with_twitch_enabled?
  end

  def after_authenticate(auth_token, existing_account: nil)
    super
  end

  def register_middleware(omniauth)
    omniauth.provider :twitch,
     SiteSetting.twitch_client_id,
     SiteSetting.twitch_client_secret,
     scope: 'user:read:email'
  end
end

auth_provider :title => 'Twitch',
    :message => 'Log in with Twitch (Make sure pop up blockers are not enabled).',
    :frame_width => 920,
    :frame_height => 800,
    :authenticator => TwitchAuthenticator.new,
    :icon => 'fab-twitch'

register_svg_icon "fab fa-twitch" if respond_to?(:register_svg_icon)

register_css <<CSS

.btn-social.twitch {
  background: #6441A5;
}

CSS
