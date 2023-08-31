# Database

```sh
dokku postgres:create metabase
dokku config:set --no-restart $DOKKU_APP \
 MB_DB_TYPE=postgres \
 MB_DB_DBNAME=metabase \
 MB_DB_PORT=5432 \
 MB_DB_USER=postgres \
 MB_DB_PASS={POSTGRES PASSWORD} \
 MB_DB_HOST={DOCKER HOST}
dokku postgres:link metabase metabase
```

# Storage

Either use the existing volumes, or make Dokku-style ones.

## Existing

The start script creates 3 directories under /home/dokku/$DOKKU_APP

* data
* metabase.db
* plugins

## Dokku Style

```sh
dokku storage:mount "$DOKKU_APP" /home/dokku/$DOKKU_APP/data:/data
dokku storage:mount "$DOKKU_APP" /home/dokku/$DOKKU_APP/metabase.db:/metabase.db
dokku storage:mount "$DOKKU_APP" /home/dokku/$DOKKU_APP/plugins:/plugins
dokku storage:ensure-directory "$DOKKU_APP"
dokku storage:ensure-directory "$DOKKU_APP/data"
dokku storage:ensure-directory "$DOKKU_APP/metabase.db"
dokku storage:ensure-directory "$DOKKU_APP/plugins"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP/data:/data"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP/metabase.db:/metabase.db"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP/plugins:/plugins"
```
