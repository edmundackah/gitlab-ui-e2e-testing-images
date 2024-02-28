#!/bin/bash
while getopts ":c:" flag
do
    case "${flag}" in
        c)  cypress_version=${OPTARG};;
    esac
done

if [ ! -z "$cypress_version" ]; then
    echo "Installing Cypress $cypress_version"
else
    cypress_version="12.10.0"
    echo "Cypress version not specified...\n Cypress $cypress_version will be installed"
fi

echo "Setting required environment variables"

# Do not send crash reports to Cypress
export CYPRESS_CRASH_REPORTS=0

# Opt out of ads in CI logs
export CYPRESS_COMMERCIAL_RECOMMENDATIONS=0

# Point Cypress to the root cache
export CYPRESS_CACHE_FOLDER="/root/.cache/Cypress"

# Point projects to globally installed Cypress
export NODE_PATH="/usr/local/lib/node_modules"

echo "Installing Cypress version $cypress_version"

wget --no-verbose -O /tmp/cypress.zip "https://cdn.cypress.io/desktop/$cypress_version/linux-x64/cypress.zip"

export CYPRESS_INSTALL_BINARY="/tmp/cypress.zip" 

npm install -g cypress@$cypress_version

# Remove Cypress zip after installation
rm /tmp/cypress.zip
unset CYPRESS_INSTALL_BINARY

# Prevent future Cypress installations from re-downloading binary
export CYPRESS_INSTALL_BINARY=0

echo "Verifying Cypress installation"
npx cypress info