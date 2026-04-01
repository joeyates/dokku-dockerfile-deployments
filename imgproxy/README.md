* Code: https://github.com/imgproxy/imgproxy
* Default Container: docker.io/darthsim/imgproxy:latest

# Set Up

Set up a DNS entry for the app

## direnv environment variables

Create and edit .envrc.private, based on .envrc

### Signed URLs

* set `IMGPROXY_KEY` and `IMGPROXY_SALT` to enable signed URLs

```sh
export IMGPROXY_KEY=$(xxd -g 2 -l 32 -p /dev/random | tr -d '\n')
export IMGPROXY_SALT=$(xxd -g 2 -l 32 -p /dev/random | tr -d '\n')
```

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

If the first attempt fails, debug using the staging server
to avoid getting rate limited.

```sh
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable $DOKKU_APP
```

When that works, switch back to production, then re-enable.

```sh
dokku letsencrypt:set $DOKKU_APP server
```

## Storage

```sh
dokku storage:mount $DOKKU_APP "$REMOTE_HOST_FILESYSTEM_ROOT:$DOKKU_IMGPROXY_LOCAL_FILESYSTEM_ROOT"
```

## Basic Configuration

```sh
dokku config:set $DOKKU_APP \
  IMGPROXY_LOCAL_FILESYSTEM_ROOT=$DOKKU_IMGPROXY_LOCAL_FILESYSTEM_ROOT \
  IMGPROXY_KEY=$IMGPROXY_KEY \
  IMGPROXY_SALT=$IMGPROXY_SALT
```

If DOKKU_IMGPROXY_PATH_PREFIX is required

```sh
dokku config:set $DOKKU_APP \
  IMGPROXY_PATH_PREFIX=$DOKKU_IMGPROXY_PATH_PREFIX \
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $CONTAINER
```

# Check

```sh
bin/check-url.exs --prefix "https://$APP_DOMAIN" --key "$IMGPROXY_KEY" --salt "$IMGPROXY_SALT" --path "/SOME%20IMAGE.jpg"
```

# Run Locally

* set `LOCAL_HOST_FILESYSTEM_ROOT` to the *host* path where the images are stored
* add `/plain/` to the URL to disable the format check
* add `/local:///` to the URL to specify the source
* URL encode the path to the image

```sh
podman pull $CONTAINER
podman run \
  --env IMGPROXY_LOCAL_FILESYSTEM_ROOT=$IMGPROXY_LOCAL_FILESYSTEM_ROOT \
  --env IMGPROXY_KEY=$IMGPROXY_KEY \
  --env IMGPROXY_SALT=$IMGPROXY_SALT \
  --volume $LOCAL_HOST_FILESYSTEM_ROOT:$IMGPROXY_LOCAL_FILESYSTEM_ROOT \
  --publish 8080:8080 \
  $CONTAINER

curl -O 'http://localhost:8080/insecure/plain/local:///SOME%20IMAGE.jpg'
```
