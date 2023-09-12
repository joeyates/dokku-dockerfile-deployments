1. Set up domain (see root README)
2. Set up environment (see root README)
3. Set up App + TLS Certificate (see root README)

# 4. Database

```sh
dokku postgres:create metabase
```

Check output for `Dsn:`

```sh
export DB_PASS={password from DSN}
export DB_HOST={host from DSN}
dokku config:set --no-restart $DOKKU_APP \
 MB_DB_TYPE=postgres \
 MB_DB_DBNAME=metabase \
 MB_DB_PORT=5432 \
 MB_DB_USER=postgres \
 MB_DB_PASS=$DB_PASS \
 MB_DB_HOST=$DB_HOST
dokku postgres:link metabase $DOKKU_APP
```

# 5. Storage

```sh
dokku storage:ensure-directory "$DOKKU_APP"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP/data:/data"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP/metabase.db:/metabase.db"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP/plugins:/plugins"
```

# 6. Ports

```sh
dokku proxy:ports-set $DOKKU_APP http:80:3000 https:443:3000
```

7. Deploy (see root README)
8. Set Up Admin User
