FROM ubuntu:jammy

ARG NODE_VERSION=20.11.1 \
    CHROME_VERSION=121.0.6167.184

# Set working directory
USER root
WORKDIR /home/node/app

# Install dependencies (curl, git, etc.)
RUN apt-get update && \
  apt-get install -y curl git wget ca-certificates fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libdbus-1-3 libdrm2 libgbm1 libglib2.0-0 libgtk-4-1 libnspr4 libnss3 libpango-1.0-0 libu2f-udev libvulkan1 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils \
  # clean up
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean  

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM
ENV NVM_DIR /root/.nvm
RUN . $NVM_DIR/nvm.sh && nvm install $NODE_VERSION

# Set default Node.js version
RUN . $NVM_DIR/nvm.sh && nvm alias default $NODE_VERSION

# Install npm (optional)
RUN . $NVM_DIR/nvm.sh && npm install -g npm

ENV NODE_PATH /root/.nvm/v$NODE_VERSION/lib/node_modules
ENV PATH /root/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

# Install Google Chrome
RUN wget --no-verbose -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_$CHROME_VERSION-1_amd64.deb" && \
    dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
    apt-get install -f -y && \
    rm -f /usr/src/google-chrome-stable_current_amd64.deb

# Configure Puppeteer to skip Chromium installation
ENV PUPPETEER_SKIP_DOWNLOAD=true

RUN npm -v && node -v