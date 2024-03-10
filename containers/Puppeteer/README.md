# Building a Docker image for running Puppeteer tests in GitLab CI

## Contents

* [Building the image](#building-the-image)
    * [Setting the Node version](#setting-the-node-version)
    * [Configuring Puppeteer executable path](#configuring-puppeteer-executable-path)

## Building the image

```bash
cd Puppeteer
docker build -t {namespace}/{image-name}:latest .
```

Pushing the image to a container registry

```sh
docker push {namespace}/{image-name}:latest
```

### Setting the Node version

The default Node version is Node 20.11.1

You can change the Node version by adding the following build arguments to the docker build command

```bash
--build-arg NODE_BASE_IMAGE="<insert node version>"
```

> **Note:** To change the Node version, you need to pick a base image from the following [repository](https://hub.docker.com/_/node) Image **tag must have the alpine suffix**

The command below is an example base image for Node 14.21.1

```bash
--build-arg NODE_BASE_IMAGE="14.21.3-alpine3.16"
```

### Configuring Puppeteer executable path

> **Note**: To use this chromium installation, set Puppeteer's executable path to `/usr/bin/chromium-browser`

Your launch code should look like the one below

```TS
  const browser = await puppeteer.launch({executablePath: '/usr/bin/chromium-browser'});
```