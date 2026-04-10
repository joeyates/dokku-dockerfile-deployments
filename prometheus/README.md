# Set Up

## direnv environment variables

Create and edit .envrc.private, based on .envrc

## Create Dokku App

```sh
dokku apps:create $DOKKU_APP
```

## Configure Storage

```sh
dokku storage:ensure-directory $DOKKU_APP
dokku storage:mount $DOKKU_APP /var/lib/dokku/data/storage/$DOKKU_APP/data:/prometheus
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $PROMETHEUS_CONTAINER:$PROMETHEUS_VERSION
```
