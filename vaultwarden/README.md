https://github.com/dani-garcia/vaultwarden

https://github.com/dani-garcia/vaultwarden/wiki/Deployment-examples#dokku

Uses SQLite DB in a host volume

Set up DNS for domain
Create and edit .envrc.private, based on .envrc

```
dokku apps:create "$DOKKU_APP"
dokku domains:set "$DOKKU_APP" $APP_DOMAIN

# Configure certificate
dokku config:set --no-restart "$DOKKU_APP" DOKKU_LETSENCRYPT_EMAIL=$DOMAIN_EMAIL
dokku config:set --no-restart "$DOKKU_APP" DOKKU_LETSENCRYPT_SERVER=staging
dokku letsencrypt:enable "$DOKKU_APP"
dokku config:unset --no-restart "$DOKKU_APP" DOKKU_LETSENCRYPT_SERVER
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

# SMTP

SMTP can be configured with these environment variables:


* SMTP_HOST=<smtp host>
* SMTP_FROM=<admin email>
* SMTP_PORT=587|465
* SMTP_SECURITY=starttls|force_tls|none
* SMTP_USERNAME=<username>
* SMTP_PASSWORD=<password>

# Admin

Available under /admin
