discourse-auth-twitch
=====================

Twitch API OAuth for Discourse

Installation Instructions (for Docker installations):

1. Open your container app.yml
2. Register a new Twitch API application at http://www.twitch.tv/kraken/oauth2/clients/new if you haven't already.
2. Under section ```env:``` your Twitch API credentials must be added:

```
  twitch_client_id: CLIENT_ID
  twitch_client_secret: CLIENT_SECRET
```

3. Under section ```hooks:``` append the following

```
          - git clone https://github.com/night/discourse-auth-twitch.git
```

4. Rebuild the docker container

```
./launcher rebuild my_image
```
