# Environment

* `LIVEBOOK_PASSWORD` - At least 12 characters

Generate a password with openssl:

```
openssl rand -base64 24
```

```sh
dokku config:set --no-restart $DOKKU_APP \
  LIVEBOOK_PASSWORD=$LIVEBOOK_PASSWORD
```

# Storage

```
dokku storage:ensure-directory "$DOKKU_APP"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP:/data"
```

# Ports

```
dokku proxy:ports-set $DOKKU_APP http:80:8080 https:443:8080
```
