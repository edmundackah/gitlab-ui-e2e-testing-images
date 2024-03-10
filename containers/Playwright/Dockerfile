# Use the playwright image as the base image
ARG PLAYWRIGHT_VERSION=1.42.0

FROM mcr.microsoft.com/playwright:v${PLAYWRIGHT_VERSION}-jammy

# Define arguments for the browsers and the node version
ARG BROWSERS
ARG NODE_VERSION

# Set working directory
USER root
WORKDIR /home/node/app

# Install dependencies
RUN apt-get update && \
  apt-get install -y \
  libicu70 \
  git \
  libffi7 \
  libx264-163

# Set the default values of the arguments
ENV BROWSERS=${BROWSERS:-chrome,webkit}
ENV NODE_VERSION=${NODE_VERSION:-20.11.1}

# Install the node version using nvm
COPY ./scripts/nvm.sh /nvm.sh

RUN /nvm.sh -n $NODE_VERSION

RUN rm /nvm.sh

# Install the playwright package and the browsers
RUN npm install playwright

COPY ./scripts/browser-install.sh /browser-install.sh

RUN /browser-install.sh -b $BROWSERS

RUN rm /browser-install.sh

# clean up
RUN rm -rf /var/lib/apt/lists/* && apt-get clean

# Create and switch to a non-root user
USER pwuser

RUN node -v

CMD echo "Image for Gitlab CI automated testing" && node