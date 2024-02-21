Create app

dokku-root plugin:install https://github.com/dokku/dokku-letsencrypt.git

Get TLS

```sh
dokku-root plugin:install https://github.com/dokku/dokku-postgres.git postgres
dokku postgres:create $DOKKU_APP
dokku postgres:link $DOKKU_APP $DOKKU_APP
```

./create-storage
chown -R 2000:2000 /var/lib/dokku/data/storage/mattermost

```sh
dokku config:get $DOKKU_APP DATABASE_URL
dokku config:set --no-restart $DOKKU_APP MM_SQLSETTINGS_DRIVERNAME=postgres MM_SQLSETTINGS_DATASOURCE='{{DATABASE URL HERE}}?sslmode=disable&connect_timeout=10'
```

```sh
dokku config:set --no-restart $DOKKU_APP TZ=Europe/Rome
dokku proxy:ports-clear $DOKKU_APP
dokku proxy:ports-remove $DOKKU_APP http:80:5000
dokku proxy:ports-remove $DOKKU_APP https:443:5000
dokku proxy:ports-add $DOKKU_APP http:80:8065
dokku proxy:ports-add $DOKKU_APP https:443:8065
```

Edit config/config.json

* Set SiteURL
* Set SMTP

```
mail.infomaniak.com
port: 465
```

Enable Push Proxy:

System Console > Environment > Push Notification Server > Enable Push Notifications
