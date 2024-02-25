FROM cypress/base:20.11.0

USER root

WORKDIR /home/node/app

# Allow installation when user is root
ENV npm_config_unsafe_perm true

# disable shared memory X11 affecting Cypress and Chrome
ENV  QT_X11_NO_MITSHM 1 \
  _X11_NO_MITSHM 1 \
  _MITSHM 0 

# Environment variables to customise browser installation
ENV CHROME_VERSION 121.0.6167.184

ENV EDGE_VERSION 110.0.1587.57

ENV CYPRESS_VERSION 12.10.0

ENV FIREFOX_VERSION 123.0

# Install dependencies
RUN apt-get update && \
  apt-get install -y \
  fonts-liberation \
  libu2f-udev \
  libvulkan1 \
  git \
  libcurl4 \
  libcurl3-gnutls \
  libcurl3-nss \
  xdg-utils \
  wget \
  zip \
  curl \
  # firefox dependencies
  bzip2 \
  # add codecs needed for video playback in firefox
  mplayer \
  # edge dependencies
  gnupg \
  dirmngr \
  # clean up
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install libappindicator3-1 - not included with Debian 11
RUN wget --no-verbose /usr/src/libappindicator3-1_0.4.92-7_amd64.deb "http://ftp.us.debian.org/debian/pool/main/liba/libappindicator/libappindicator3-1_0.4.92-7_amd64.deb" && \
  dpkg -i /usr/src/libappindicator3-1_0.4.92-7_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/libappindicator3-1_0.4.92-7_amd64.deb

RUN echo "Downloading Chrome version: ${CHROME_VERSION}"

# install Chrome browser
RUN wget --no-verbose -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" && \
  dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/google-chrome-stable_current_amd64.deb

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN echo "Downloading Firefox version: ${FIREFOX_VERSION}"

# install Firefox browser
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-GB/firefox-${FIREFOX_VERSION}.tar.bz2" && \
  tar -C /opt -xjf /tmp/firefox.tar.bz2 && \
  rm /tmp/firefox.tar.bz2 && \
  ln -fs /opt/firefox/firefox /usr/bin/firefox

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

RUN echo "Downloading Edge ${EDGE_VERSION}"

# install Edge browser
RUN wget --no-verbose -O /usr/src/microsoft-edge-stable_amd64.deb "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_${EDGE_VERSION}-1_amd64.deb" && \
  dpkg -i /usr/src/microsoft-edge-stable_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/microsoft-edge-stable_amd64.deb

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "Chrome version:  $(google-chrome-stable --version) \n" \
  "Firefox version: $(firefox --version) \n" \
  "Edge version:    $(microsoft-edge-stable --version) \n" \ 
  "git version:     $(git --version) \n" \
  "whoami:          $(whoami) \n"

# Verify Cypress installation
RUN npx cypress info

CMD echo "Image for Gitlab CI automated testing" && node