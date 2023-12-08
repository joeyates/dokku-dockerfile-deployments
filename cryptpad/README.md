# Deploy a Cryptpad Container via Dokku

# Development

To try this out locally

```sh
ln -s development-config.js config/config.js
```

```sh
docker run \
  --rm \
  -ti \
  -e CPAD_CONF=/cryptpad/config/config.js \
  -e CPAD_MAIN_DOMAIN=0.0.0.0 \
  -e CPAD_SANDBOX_DOMAIN=0.0.0.0/sandbox \
  -p 3000:3000 \
  -p 3001:3001 \
  -p 3002:3002 \
  -v $PWD/config:/cryptpad/config \
  --name cryptpad \
  cryptpad/cryptpad:version-5.5.0
```

The site will be available at `http://127.0.0.1:3000/`


