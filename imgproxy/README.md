* Code: https://github.com/imgproxy/imgproxy
* Container: docker.io/darthsim/imgproxy:latest

# Set Up Dokku

* Set up a DNS entry for the app
* Create and edit .envrc.private, based on .envrc

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN

dokku config:set --no-restart $DOKKU_APP \
  IMGPROXY_LOCAL_FILESYSTEM_ROOT=$DOKKU_IMGPROXY_LOCAL_FILESYSTEM_ROOT

# If DOKKU_IMGPROXY_PATH_PREFIX is required:
dokku config:set --no-restart $DOKKU_APP \
  IMGPROXY_PATH_PREFIX=$DOKKU_IMGPROXY_PATH_PREFIX

dokku storage:mount $DOKKU_APP "$REMOTE_HOST_FILESYSTEM_ROOT:$DOKKU_IMGPROXY_LOCAL_FILESYSTEM_ROOT"
dokku git:from-image $DOKKU_APP $CONTAINER

# Configure certificate
dokku ports:set $DOKKU_APP http:80:8080
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
# To avoid getting rate limited, use staging first
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable $DOKKU_APP
# Switch to production
dokku letsencrypt:set $DOKKU_APP server
dokku letsencrypt:enable $DOKKU_APP
```

# Signed URLs

* set `IMGPROXY_KEY` and `IMGPROXY_SALT` to enable signed URLs

```sh
export IMGPROXY_KEY=$(xxd -g 2 -l 32 -p /dev/random | tr -d '\n')
export IMGPROXY_SALT=$(xxd -g 2 -l 32 -p /dev/random | tr -d '\n')
dokku config:set --no-restart $DOKKU_APP \
  IMGPROXY_KEY=$IMGPROXY_KEY \
  IMGPROXY_SALT=$IMGPROXY_SALT
```

# Run Locally

* set `HOST_FILESYSTEM_ROOT` to the *host* path where the images are stored
* add `/plain/` to the URL to disable the format check
* add `/local:///` to the URL to specify the source
* URL encode the path to the image

```sh
podman pull $CONTAINER
podman run \
  --env IMGPROXY_LOCAL_FILESYSTEM_ROOT=$IMGPROXY_LOCAL_FILESYSTEM_ROOT \
  --env IMGPROXY_KEY=$IMGPROXY_KEY \
  --env IMGPROXY_SALT=$IMGPROXY_SALT \
  --volume $HOST_FILESYSTEM_ROOT:$IMGPROXY_LOCAL_FILESYSTEM_ROOT \
  --publish 8080:8080 \
  -it \
  $CONTAINER

curl -O 'http://localhost:8080/insecure/plain/local:///SOME%20IMAGE.jpg'
```

# Other Configuration

* `IMGPROXY_PATH_PREFIX` - insert a prefix before the path
