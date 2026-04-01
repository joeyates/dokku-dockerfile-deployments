# Set Up

Set up a DNS entry for the app

## direnv environment variables

Create and edit .envrc.private, based on .envrc

## Create Dokku App

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN
```

## Configure certificate

```sh
dokku ports:set $DOKKU_APP http:80:2283
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
# To avoid getting rate limited, use staging first
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable $DOKKU_APP
# Switch to production
dokku letsencrypt:set $DOKKU_APP server
dokku letsencrypt:enable $DOKKU_APP
```

## Configure Storage

```sh
dokku storage:ensure-directory $DOKKU_APP
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP/data:/data
```

## Set Up Database

```sh
dokku postgres:create $DOKKU_APP --image $POSTGRES_IMAGE --image-version $POSTGRES_IMAGE_VERSION
dokku postgres:link $DOKKU_APP $DOKKU_APP
```

## Set Up Redis

```sh
dokku redis:create $DOKKU_APP --image $REDIS_IMAGE --image-version $REDIS_IMAGE_VERSION
dokku redis:link $DOKKU_APP $DOKKU_APP
```

## Configure nginx

```sh
dokku nginx:set $DOKKU_APP client-max-body-size 3g
```

## Configure Environemnt

Copy redis and postgres passwords and hostnames from the link URLs
to their respective environment variables:

```sh
bin/copy-service-settings
```

Optionally set timezone

```sh
dokku config:set $DOKKU_APP --no-restart \
  TZ={{TIMEZONE}}
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $CONTAINER
```
