# Building a Docker image for running Cypress tests in GitLab CI

> **Note:** The Dockerfile provided in this directory can be used to build a heavy image with 4 browsers and Cypress. Follow the steps below to customise it.

## Contents

* [Building a Node 14 image](#building-a-node-14-image)
    * [Using Node 20 base image](#using-node-20-base-image)
    * [Configuring Cypress version](#configuring-cypress-version)
    * [Chrome browser support]()
    * [Firefox browser support](#adding-firefox-to-the-image)
    * [Edge browser support](#edge-browser-support)
* [Building the image](#building-the-image)  
* [Verify Cypress installation](#verify-cypress-installation)  

## Building a Node 14 image

> **Note:** The Dockerfile below includes the Cypress binary, required system dependencies and **only the electron browser**

```Dockerfile
FROM  cypress/base:14.21.1

USER root

WORKDIR /home/node/app

# Allow installation when user is root
ENV npm_config_unsafe_perm true

# disable shared memory X11 affecting Cypress and Chrome
ENV  QT_X11_NO_MITSHM 1 \
  _X11_NO_MITSHM 1 \
  _MITSHM 0 

ENV CYPRESS_VERSION 12.10.0

# Install dependencies
RUN apt-get update && \
  apt-get install -y \
  fonts-liberation \
  git \
  libcurl4 \
  libcurl3-gnutls \
  libcurl3-nss \
  xdg-utils \
  wget \
  zip \
  curl \
  # clean up
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install libappindicator3-1 - not included with Debian 11
RUN wget --no-verbose /usr/src/libappindicator3-1_0.4.92-7_amd64.deb "http://ftp.us.debian.org/debian/pool/main/liba/libappindicator/libappindicator3-1_0.4.92-7_amd64.deb" && \
  dpkg -i /usr/src/libappindicator3-1_0.4.92-7_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/libappindicator3-1_0.4.92-7_amd64.deb

# "fake" dbus address to prevent errors
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN echo "Downloading Cypress ${CYPRESS_VERSION}"

# Do not send crash reports to Cypress
ENV CYPRESS_CRASH_REPORTS 0

# Opt out of ads in CI logs
ENV CYPRESS_COMMERCIAL_RECOMMENDATIONS 0

# Point Cypress to the root cache
ENV CYPRESS_CACHE_FOLDER /root/.cache/Cypress

# Point projects to globally installed Cypress
ENV NODE_PATH /usr/local/lib/node_modules

RUN wget --no-verbose -O /tmp/cypress.zip "https://cdn.cypress.io/desktop/${CYPRESS_VERSION}/linux-x64/cypress.zip"

ENV CYPRESS_INSTALL_BINARY /tmp/cypress.zip 

RUN npm install -g cypress@${CYPRESS_VERSION}

# Remove Cypress zip after installation
RUN rm /tmp/cypress.zip

# Prevent future Cypress installations from re-downloading binary
ENV CYPRESS_INSTALL_BINARY 0

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "git version:     $(git --version) \n" \
  "whoami:          $(whoami) \n"

# Verify Cypress installation
RUN npx cypress info

CMD echo "Image for Gitlab CI automated testing" && node
```

### Configuring Cypress version

Cypress binary version built into the image can be altered using the `CYPRESS_VERSION` environment variable. The default Cypress version is `12.10.0`

```Dockerfile
ENV CYPRESS_VERSION 12.10.0
```

### Using Node 20 base image

The Dockerfile above is validated to work with the Node 20 Cypress base image below

```Dockerfile
FROM cypress/base:20.11.0
```

### Adding Chrome to the image

Add the commands below to your Dockerfile to install Chrome

```Dockerfile
ENV CHROME_VERSION 121.0.6167.184

RUN echo "Downloading Chrome version: ${CHROME_VERSION}"

# install Chrome browser
RUN wget --no-verbose -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" && \
  dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/google-chrome-stable_current_amd64.deb
```

### Adding Firefox to the image

Add the commands below to your Dockerfile to install Firefox

```Dockerfile
ENV FIREFOX_VERSION 123.0

# Install firefox dependencies
RUN apt-get update && \
  apt-get install -y \
  bzip2 \
  # add codecs needed for video playback in firefox
  mplayer \
  # clean up
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install Firefox browser
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-GB/firefox-${FIREFOX_VERSION}.tar.bz2" && \
  tar -C /opt -xjf /tmp/firefox.tar.bz2 && \
  rm /tmp/firefox.tar.bz2 && \
  ln -fs /opt/firefox/firefox /usr/bin/firefox
```

### Edge browser support
Add the commands below to your Dockerfile to install Edge

```Dockerfile
ENV EDGE_VERSION 110.0.1587.57

# Install Edge dependencies
RUN apt-get update && \
  apt-get install -y \
  gnupg \
  dirmngr \
  # clean up
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN echo "Downloading Edge ${EDGE_VERSION}"

# install Edge browser
RUN wget --no-verbose -O /usr/src/microsoft-edge-stable_amd64.deb "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_${EDGE_VERSION}-1_amd64.deb" && \
  dpkg -i /usr/src/microsoft-edge-stable_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/microsoft-edge-stable_amd64.deb
```

## Building the image

Build the image with a version tag

```bash
cd Cypress
docker build -t {namespace}/{image-name}:latest .
```

Pushing the image to a container registry

```sh
docker push {namespace}/{image-name}:latest
```

## Verify Cypress installation
To confirm the Cypress installation was successful, check the contents of the command `RUN npx cypress info` in your docker build logs. It should re-semble the one below.

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
  - Version: 110.0.1587.57
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