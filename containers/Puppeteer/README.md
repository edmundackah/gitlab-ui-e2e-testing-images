# Building a Docker image for running Puppeteer in GitLab CI

## Contents

* [Building a Node 14 image](#building-a-node-14-image)
    * [Using Node 20 base image](#using-node-20-base-image)
    * [Firefox browser support](#adding-firefox-to-the-image)
* [Building the image](#building-the-image)    

## Building a Node 14 image

> **Note**: The image described below includes the chromium browser but not Puppeteer. The version specified in your project's package.json is used to run the tests.

```Dockerfile
FROM node:14.21.3-alpine3.16

# Installs latest Chromium (121) package.
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont

# Configure Puppeteer to skip Chromium installation
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

CMD echo "Image for Gitlab CI automated testing" && node
```

> **Note**: To use this chromium installation, set Puppeteer's executable path to `/usr/bin/chromium-browser`

Your launch code should look like the one below

```TS
  const browser = await puppeteer.launch({executablePath: '/usr/bin/chromium-browser'});
```

### Using Node 20 base image

The Dockerfile above is validated to work with the Node 20 base image below

```Dockerfile
FROM node:20.11.1-alpine3.19
```

### Adding Firefox to the image

Add the command below to your Dockerfile to install Firefox

```Dockerfile
RUN apk add firefox
```

> **Note**: To run Puppeteer with the Firefox, set Puppeteer's executable path to `usr/bin/firefox`

Your launch code should look like the one below
```TS
  const browser = await puppeteer.launch({
    product: 'firefox', executablePath: '/usr/bin/firefox'});
```

## Building the image

Build the image with a version tag

```bash
cd Puppeteer
docker build -t {namespace}/{image-name}:latest .
```

Pushing the image to a container registry

```sh
docker push {namespace}/{image-name}:latest
```