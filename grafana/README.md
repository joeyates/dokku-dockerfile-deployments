# Set Up

## direnv environment variables

Create and edit .envrc.private, based on .envrc

## Create Dokku App

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN
```

## Configure certificate

```sh
dokku ports:set $DOKKU_APP http:80:$APP_PORT
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
dokku letsencrypt:enable $DOKKU_APP
```

## Configure Storage

```sh
dokku storage:ensure-directory $DOKKU_APP
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP:/var/lib/grafana
ssh root@$DOKKU_HOST "chown -R 472:472 /var/lib/dokku/data/storage/$DOKKU_APP"
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $GRAFANA_CONTAINER:$GRAFANA_VERSION
```
