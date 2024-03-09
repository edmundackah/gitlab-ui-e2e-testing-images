# Building a Docker image for running Cypress tests in GitLab CI

> **Note:** The Dockerfile provided in this directory can be used to build a docker image with 4 browsers and Cypress. Follow the steps below to customise it.

## Contents

* [Building the image](#building-the-image)
    * [Setting Node version](#setting-node-version)
    * [Build Arguments](#build-arguments)
* [Verify Cypress installation](#verify-cypress-installation)  

## Building the image

### Setting Node version

The default node version for this Docker image is Node 14.21.1

You can change the Node version by adding the following build arguments to the docker build command

```bash
--build-arg NODE="<insert node version>"
```

### Build arguments

The Docker image can be customised by passing build arguments in your docker build commands. The table below is an example for building an image with Node 20, Cypress and 4 different browsers (Cypress binary comes bundled with the electron browser)

| Arguments 	| Values         	|
|-----------	|----------------	|
| NODE      	| 20.11.0        	|
| CYPRESS   	| 12.10.0        	|
| EDGE      	| 122.0.2365.59  	|
| CHROME    	| 121.0.6167.184 	|
| FIREFOX   	| 123.0          	|

> **Note:** Node version is optional (default version is 14.21.1) The browser arguments are optional. If a Cypress version is not specified, the script will default to `Cypress 12.10.0` 

### Building the image

Running this command below, will build an image using the arguments specified in the table above.

> **Note:** It is good practice to replace the `latest` tag with a version number to version your images

```bash
docker build -t {namespace}/{image-name}:latest --build-arg NODE="20.11.0" --build-arg CYPRESS="12.10.0" --build-arg EDGE="122.0.2365.59" --build-arg CHROME="121.0.6167.184" --build-arg FIREFOX="123.0" .
```

#### Minimal image

Running the build command below creates an image with just Node 20.11.0 and Cypress 12.10.0

```sh
docker build -t {namespace}/{image-name}:latest --build-arg NODE="20.11.0" .
```

#### Pushing the image

Pushing the image to a container registry

```sh
docker push {namespace}/{image-name}:latest
```

## Verify Cypress installation
To confirm the Cypress installation was successful, check the contents of the command `RUN /cypress-install.sh -c $CYPRESS` in your docker build logs. It should resemble the one below.

```ts
Detected 3 browsers installed:
1. Chrome
  - Name: chrome
  - Channel: stable
  - Version: 121.0.6167.184
  - Executable: google-chrome
2. Edge
  - Name: edge
  - Channel: stable
  - Version: 122.0.2365.59 
  - Executable: microsoft-edge
3. Firefox
  - Name: firefox
  - Channel: stable
  - Version: 123.0
  - Executable: firefox
Note: to run these browsers, pass <name>:<channel> to the '--browser' field
Examples:
- cypress run --browser chrome
- cypress run --browser edge
Learn More: https://on.cypress.io/launching-browsers
Proxy Settings: none detected
Environment Variables:
CYPRESS_FACTORY_DEFAULT_NODE_VERSION: 20.11.0
CYPRESS_VERSION: 12.10.0
CYPRESS_COMMERCIAL_RECOMMENDATIONS: 0
CYPRESS_CRASH_REPORTS: 0
CYPRESS_CACHE_FOLDER: /root/.cache/Cypress
CYPRESS_INSTALL_BINARY: 0
Application Data: /root/.config/cypress/cy/development
Browser Profiles: /root/.config/cypress/cy/development/browsers
Binary Caches: /root/.cache/Cypress
Cypress Version: 12.10.0 (stable)
System Platform: linux (Debian - 11.8)
System Memory: 8.35 GB free 7.48 GB
```