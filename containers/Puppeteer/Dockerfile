#FROM node:14.21.3-alpine3.16

FROM node:20.11.1-alpine3.19

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