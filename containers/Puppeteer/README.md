# Building a Docker image for running Puppeteer tests in GitLab CI

## Contents

* [Building the image](#building-the-image)
    * [Setting the Node version](#setting-the-node-version)
    * [Setting Chrome version](#setting-chrome-version)
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

You can change the Node version by adding the following build argument to the docker build command

```bash
--build-arg NODE_VERSION="<insert node version>"
```

The command below is an example of how to install Node 14.21.1

```bash
--build-arg NODE_VERSION="14.21.1"
```

### Setting Chrome version

> **Note:** This image supports only Google Chrome stable releases

The default Chrome version is 121.0.6167.184

You can change the Chrome version by adding the following build argument to the docker build command

```bash
--build-arg CHROME_VERSION="<insert chrome version>"
```

### Configuring Puppeteer executable path

Your launch code should look like the one below

```TS
  const browser = await puppeteer.launch({executablePath: '/usr/bin/google-chrome-stable', args: ['--no-sandbox']});
```