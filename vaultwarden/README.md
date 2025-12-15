https://github.com/dani-garcia/vaultwarden

https://github.com/dani-garcia/vaultwarden/wiki/Deployment-examples#dokku

Uses SQLite DB in a host volume

# Setup

Set up DNS for domain

## ADMIN_TOKEN

Generate a random password (which should be stored securely):

```sh
pwgen 64 1
```

Then generate the hash:

```sh
podman run --rm -it vaultwarden/server /vaultwarden hash --preset owasp
```

Create and edit .envrc.private, based on .envrc.

When setting the ADMIN_TOKEN, use the hashed value with '$' escaped, e.g.

```sh
\$
```

### SMTP

SMTP can be configured with these environment variables in `.envrc.private`:

```sh
SMTP_HOST=<smtp host>
SMTP_FROM=<admin email>
SMTP_PORT=587|465
SMTP_SECURITY=starttls|force_tls|none
SMTP_USERNAME=<username>
SMTP_PASSWORD=<password>
```

## Create App

```sh
dokku apps:create $DOKKU_APP
dokku domains:set $DOKKU_APP $APP_DOMAIN
```

## Set Environment Variables

```sh
dokku config:set $DOKKU_APP \
  ADMIN_TOKEN="$VAULTWARDEN_ADMIN_TOKEN" \
  DOMAIN=https://$APP_DOMAIN \
  SMTP_HOST=$SMTP_HOST \
  SMTP_FROM=$SMTP_FROM \
  SMTP_PORT=$SMTP_PORT \
  SMTP_SECURITY=$SMTP_SECURITY \
  SMTP_USERNAME=$SMTP_USERNAME \
  SMTP_PASSWORD=$SMTP_PASSWORD
```

Other optional settings:

* `SIGNUPS_ALLOWED=true|false` to enable|disable user signups
* `INVITATIONS_ALLOWED=true|false` to enable|disable invitations

## Storage

```sh
dokku storage:ensure-directory $DOKKU_APP
dokku storage:mount $DOKKU_APP "/var/lib/dokku/data/storage/$DOKKU_APP:/data"
```

## Certificate

```sh
dokku ports:set $DOKKU_APP http:80:80
dokku letsencrypt:set $DOKKU_APP email $DOMAIN_EMAIL
dokku letsencrypt:set $DOKKU_APP server staging
dokku letsencrypt:enable $DOKKU_APP
dokku letsencrypt:set $DOKKU_APP server
dokku letsencrypt:enable $DOKKU_APP
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $CONTAINER
```

# Backups

```sh
mkdir -p /var/backups/dokku/vaultwarden
chmod 0700 /var/backups/dokku/vaultwarden
```

Add to root crontab

```crontab
0 3 * * * sqlite3 /var/lib/dokku/data/storage/vaultwarden/db.sqlite3 ".backup '/var/backups/dokku/vaultwarden/db-$(date '+\%Y\%m\%d-\%H\%M').sqlite3'"
```

# Restore Database

N.B. This assumes an SQLite database.

```sh
dokku ps:stop $DOKKU_APP
```

Copy the backup to `"/var/lib/dokku/data/storage/$DOKKU_APP"`

```sh
dokku ps:start $DOKKU_APP
```

# Admin

Available under /admin
