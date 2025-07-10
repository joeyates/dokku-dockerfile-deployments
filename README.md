# Overview

The command `dokku git:from-image` allows you to deploy a Docker image.

It initializes a Git repo, adding a Dockerfile
with a reference to the Docker image.

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

# App

Create the app

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN
```

# Storage

Optionally, set up storage

```sh
dokku storage:ensure-directory $DOKKU_APP
dokku storage:mount $DOKKU_APP "/var/lib/dokku/data/storage/$DOKKU_APP:/PATH/IN/CONTAINER"
```

# Deploy

Deploy the image

```sh
dokku git:from-image $DOKKU_APP $DOCKER_IMAGE
```

# TLS Certificate

Set up the TLS certificate

```sh
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
# First check that we can get a certificate from the staging server
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable $DOKKU_APP
# N.B. - This may hang.
#   As long as you see the message `Validations succeeded`, it's OK.
#   You can then interrupt it with Ctrl+C
dokku letsencrypt:set $DOKKU_APP server
dokku letsencrypt:enable $DOKKU_APP
```

# Modifications

If, after deployment, you want to modify anything,
you can proceed by working on the Git repo,
like with any other Dokku Dockerfile deployment.

```sh
git clone --origin dokku dokku@$DOKKU_HOST:$DOKKU_APP
```
