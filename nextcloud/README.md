# Installation

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN
```

## Storage

On server

```sh
mkdir -p /var/lib/dokku/data/storage/$DOKKU_APP/{config,data}
chown www-data:www-data /var/lib/dokku/data/storage/$DOKKU_APP/{config,data}
```

On client

```sh
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP/data:/var/www/html/data
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP/config:/var/www/html/config
```

## Database

```sh
dokku postgres:create $DOKKU_APP --image postgis/postgis --image-version $POSTGRES_IMAGE
dokku postgres:link $DOKKU_APP $DOKKU_APP
```

## Redis

```sh
dokku-root plugin:install https://github.com/dokku/dokku-redis.git redis
dokku redis:create $DOKKU_APP
dokku redis:link $DOKKU_APP $DOKKU_APP
```

PHP and Nginx settings:

```sh
dokku config:set $DOKKU_APP --no-restart PHP_MEMORY_LIMIT=4G PHP_UPLOAD_LIMIT=3G
dokku nginx:set $DOKKU_APP client-max-body-size 3g
```

## Configure certificate

```sh
dokku ports:set $DOKKU_APP http:80:80
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
# To avoid getting rate limited, use staging first
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable $DOKKU_APP
# Switch to production
dokku letsencrypt:set $DOKKU_APP server
dokku letsencrypt:enable $DOKKU_APP
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $CONTAINER
```
