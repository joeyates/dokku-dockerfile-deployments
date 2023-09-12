# Overview

The command

```
dokku git:from-image $DOKKU_APP $DOCKER_IMAGE
```

initializes a Git repo, adding a Dockerfile
with a reference to the Docker image.

# Modifications

If, after deployment, you want to modify anything,
you can proceed by working on the Git repo,
like with any other Dokku Dockerfile deployment.

```
git clone --origin dokku dokku@$DOKKU_HOST:$DOKKU_APP
```

# Domain

Choose and set up the domain name on nameserver.

Check that the domain resolves.

# Set up the environment

```sh
export DOCKER_IMAGE=XXXXX
export DOKKU_APP=XXXXX
export DOMAIN_EMAIL=XXXXX
export APP_DOMAIN=XXXXX
```

# App + TLS Certificate

Create the app and set up the TLS certificate

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN

dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
# or, old:
dokku config:set --no-restart $DOKKU_APP DOKKU_LETSENCRYPT_EMAIL=$DOMAIN_EMAIL

dokku letsencrypt:set $DOKKU_APP server staging
# or, old:
dokku config:set --no-restart $DOKKU_APP DOKKU_LETSENCRYPT_SERVER=staging

dokku letsencrypt:enable $DOKKU_APP

dokku letsencrypt:set $DOKKU_APP server default
# or, old:
dokku config:unset --no-restart $DOKKU_APP DOKKU_LETSENCRYPT_SERVER

dokku letsencrypt:enable $DOKKU_APP
```

# Storage

Optionally, set up storage

```sh
dokku storage:ensure-directory "$DOKKU_APP"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP:/PATH/IN/CONTAINER"
```

# Deploy

Deploy the image

```sh
dokku git:from-image $DOKKU_APP $DOCKER_IMAGE
```
