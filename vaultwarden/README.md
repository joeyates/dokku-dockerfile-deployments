https://github.com/dani-garcia/vaultwarden

https://github.com/dani-garcia/vaultwarden/wiki/Deployment-examples#dokku

Uses SQLite DB in a host volume

Set up DNS for domain
Create and edit .envrc.private, based on .envrc

```
dokku apps:create "$DOKKU_APP"
dokku domains:set "$DOKKU_APP" $APP_DOMAIN

# Configure certificate
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable "$DOKKU_APP"
dokku letsencrypt:set $DOKKU_APP server
dokku letsencrypt:enable "$DOKKU_APP"

dokku proxy:ports-set "$DOKKU_APP" https:443:80

# If you want the admin interface:
dokku config:set --no-restart "$DOKKU_APP" ADMIN_TOKEN="$VAULTWARDEN_ADMIN_TOKEN"
# If you want to disable registration (invite only)
dokku config:set --no-restart "$DOKKU_APP" SIGNUPS_ALLOWED=false

dokku storage:ensure-directory "$DOKKU_APP"
dokku storage:mount "$DOKKU_APP" "/var/lib/dokku/data/storage/$DOKKU_APP:/data"
dokku git:from-image "$DOKKU_APP" $DOCKER_IMAGE
```

# Backups

```
mkdir -p /var/backups/dokku/vaultwarden
```

Add to root crontab

```
0 3 * * * sqlite3 /var/lib/dokku/data/storage/vaultwarden/db.sqlite3 ".backup '/var/backups/dokku/vaultwarden/db-$(date '+\%Y\%m\%d-\%H\%M').sqlite3'"
```

# Restore Database

N.B. This assumes an SQLite database.

```
dokku ps:stop "$DOKKU_APP"
```

Copy the backup to `"/var/lib/dokku/data/storage/$DOKKU_APP"`

```
dokku ps:start "$DOKKU_APP"
```

# SMTP

SMTP can be configured with these environment variables in `.envrc.private`:

```
SMTP_HOST=<smtp host>
SMTP_FROM=<admin email>
SMTP_PORT=587|465
SMTP_SECURITY=starttls|force_tls|none
SMTP_USERNAME=<username>
SMTP_PASSWORD=<password>
```

```
dokku config:set $DOKKU_APP --no-restart SMTP_HOST=$SMTP_HOST SMTP_FROM=$SMTP_FROM SMTP_PORT=$SMTP_PORT SMTP_SECURITY=$SMTP_SECURITY SMTP_USERNAME=$SMTP_USERNAME SMTP_PASSWORD=$SMTP_PASSWORD
```


# Admin

Available under /admin

## Configuration Via Admin

Set the "Domain URL"
