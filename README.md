discourse-auth-twitch
=====================

Twitch Auth for Discourse

Installation Instructions (for Docker installations):

* Open your container app.yml
* Register a new Twitch API application at https://dev.twitch.tv/console/apps if you haven't already.
  * For the Redirect API: http(s)://example.com/auth/twitch/callback
* Under section ```env:``` your Twitch API credentials must be added:
```
  TWITCH_CLIENT_ID: CLIENT_ID
  TWITCH_CLIENT_SECRET: CLIENT_SECRET
```
* Under section ```hooks:``` append the following
```
          - git clone https://github.com/night/discourse-auth-twitch.git
```
* Rebuild the docker container
```
./launcher rebuild my_image
```
