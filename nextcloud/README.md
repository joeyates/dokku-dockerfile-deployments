# Installation

Follow the README in the project root, inserting the modifications listed below

## Modifications

On server

```sh
mkdir -p /var/lib/dokku/data/storage/$DOKKU_APP/{config,data}
chown www-data:www-data /var/lib/dokku/data/storage/$DOKKU_APP/{config,data}
```

On client

Storage:

```sh
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP/data:/var/www/html/data
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP/config:/var/www/html/config
```

Postgres:

```sh
dokku postgres:create $DOKKU_APP --image postgis/postgis --image-version $POSTGRES_IMAGE
dokku postgres:link $DOKKU_APP $DOKKU_APP
```

Redis:

```sh
dokku plugin:install https://github.com/dokku/dokku-redis.git redis
dokku redis:create $DOKKU_APP
dokku redis:link nextcloud $DOKKU_APP
```

PHP and Nginx settings:

```sh
dokku config:set $DOKKU_APP --no-restart PHP_MEMORY_LIMIT=4G PHP_UPLOAD_LIMIT=3G
dokku nginx:set $DOKKU_APP client-max-body-size 3g
dokku ps:rebuild $DOKKU_APP
```
