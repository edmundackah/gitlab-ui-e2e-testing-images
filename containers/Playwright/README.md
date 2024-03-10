# Building a Docker image for running Playwright tests in GitLab CI

## Contents

* [Building the image](#building-the-image)
    * [Setting Playwright version](#setting-playwright-version)
    * [Setting required Browsers](#setting-required-browsers)
    * [Node verison](#node-version)

## Building the image

```bash
cd Playwright
docker build -t {namespace}/{image-name}:latest .
```

Pushing the image to a container registry

```sh
docker push {namespace}/{image-name}:latest
```

### Setting Playwright version

The default Playwright version is 1.42.0

You can change the Playwright version by adding the following build arguments to the docker build command

```bash
--build-arg PLAYWRIGHT_VERSION="1.39.0"
```

### Setting required Browsers

The default Browsers configured with Playwright are Chrome and Webkit.

At the time of writing Playwright supports the following Browsers:

| Browsers                        	|
|---------------------------------	|
| chromium, chrome, chrome-beta   	|
| msedge, msedge-beta, msedge-dev 	|
| firefox, firefox-asan           	|
| webkit                          	|

You can change the Browser selection by adding the following build arguments to the docker build command

```bash
--build-arg BROWSERS="firefox"
```

> **Note:** Multiple Browser installations is supported by passing a command separated list, like the example below.

```bash
--build-arg BROWSERS="chromium,firefox"
```

### Node version

The default Node version is Node 20.11.1

You can change the Node version by adding the following build arguments to the docker build command

```bash
--build-arg NODE="<insert node version>"
```

> **Note:** Multiple Node installations is supported by passing a command separated list, like the example below.

```bash
--build-arg NODE="14.16.1,20.11.1"
```