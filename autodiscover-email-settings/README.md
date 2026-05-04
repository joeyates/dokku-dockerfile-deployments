# Set Up

## direnv environment variables

Create and edit .envrc.private, based on .envrc

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

## Decide How to Set Up the _SOCKET Environment Variables

Ths table shows the recommended values for the _SOCKET environment variables, based on
the port that the IMAP and SMTP servers are configured to listen on.

+------------+---------+----------------+-------------+
| SERVICE    | PORT    | VARIABLE       | VALUE       |
+------------+---------+----------------+-------------+
| IMAP       | 143     | IMAP_SOCKET    | STARTTLS    |
| IMAP       | 993     | IMAP_SOCKET    | SSL         |
| SMTP       | 587     | SMTP_SOCKET    | STARTTLS    |
| SMTP       | 465     | SMTP_SOCKET    | SSL         |
+------------+---------+----------------+-------------+

## Set Environent Variables

```sh
dokku config:set $DOKKU_APP \
  COMPANY_NAME=$COMPANY_NAME \
  SUPPORT_URL=https://$APP_DOMAIN \
  DOMAIN=$DOMAIN \
  IMAP_HOST=$IMAP_HOST \
  IMAP_PORT=$IMAP_PORT \
  IMAP_SOCKET=$IMAP_SOCKET \
  SMTP_HOST=$SMTP_HOST \
  SMTP_PORT=$SMTP_PORT \
  SMTP_SOCKET=$SMTP_SOCKET
```

## Deploy

```sh
dokku git:from-image $DOKKU_APP $CONTAINER:$CONTAINER_VERSION
```
