ARG NODE 14.21.1

FROM cypress/base:$NODE

USER root

WORKDIR /home/node/app

# Allow installation when user is root
ENV npm_config_unsafe_perm true

# disable shared memory X11 affecting Cypress and Chrome
ENV  QT_X11_NO_MITSHM 1 \
  _X11_NO_MITSHM 1 \
  _MITSHM 0 

# Build arguments to customise browser and Cypress installation
ARG CHROME \
  EDGE \
  CYPRESS \
  FIREFOX

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
  # clean up
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install libappindicator3-1 - not included with Debian 11
RUN wget --no-verbose /usr/src/libappindicator3-1_0.4.92-7_amd64.deb "http://ftp.us.debian.org/debian/pool/main/liba/libappindicator/libappindicator3-1_0.4.92-7_amd64.deb" && \
  dpkg -i /usr/src/libappindicator3-1_0.4.92-7_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/libappindicator3-1_0.4.92-7_amd64.deb

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# Browser install scripts
COPY ./scripts/browser-install.sh /browser-install.sh

RUN /browser-install.sh -e $EDGE -c $CHROME -f $FIREFOX

RUN rm /browser-install.sh

# Verify installation(s)
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "Chrome version:  $(google-chrome-stable --version) \n" \
  "Firefox version: $(firefox --version) \n" \
  "Edge version:    $(microsoft-edge-stable --version) \n"

# Cypress install scripts
COPY ./scripts/cypress-install.sh /cypress-install.sh

RUN /cypress-install.sh -c $CYPRESS

RUN rm /cypress-install.sh

CMD echo "Image for Gitlab CI automated testing" && node