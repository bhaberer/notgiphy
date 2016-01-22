# Not Giphy

Because giphy slack sucks

# Usage

## Create an Imgur app

  1. Go to https://api.imgur.com/oauth2/addclient
  2. Select `OAuth 2 authorization without a callback URL`
  3. Enter any other details necessary, and create the client.
  4. Copy down the appid

## Set up an incomming webhook on Slack

  1. Go to https://[your-team].slack.com/services/new/incoming-webhook
  2. Copy down the '/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX' part of the 'Webhook URL'
  3. At the bottom change the name of the integration if you want, and save it.

## Deploying on Heroku

    $ wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    $ heroku login
    $ heroku create mynotgiphy
    $ heroku config:set SLACK_URI=https://hooks.slack.com \
      SLACK_ENDPOINT=/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX \
      IMGUR_APP_ID=XXXXXXXXXXXXXXX \
      --app mynotgiphy
    $ git push heroku master

## Set up a slash command on Slack

  1. Go to https://your-team.slack.com/services/new/slash-commands
  2. In the box, type `/notgiphy` and select `Add Slash Command`
  3. For URL put the link to the root of your Heroku repo, e.g. `http://mynotgiphy.herokuapp.com/`
  4. Feel free to customize the name, icon, and help text.

# Copyright

Copyright (C) 2015 Carla Souza <carlasouza.com>.

License GPLv3+: GNU GPL version 3 or later <gnu.org/licenses/gpl.html>. This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.
