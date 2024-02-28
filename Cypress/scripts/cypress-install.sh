#!/bin/sh

while getopts ":v:" flag
do
    case "${flag}" in
        v)  cypress_versions=${OPTARG};;
    esac
done

IFS=', ' read -r -a array <<< "$cypress_versions"

for element in "${array[@]}"
do
    echo "reading values: $element"
    install_cypress "$element"
done

install_cypress() {
    version = "$1"

    if [ ! -z "$version" ]; then
        echo "Installing Cypress $version"
    else
        version="12.10.0"
        echo "Cypress version not specified...\n Cypress $version will be installed"
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

    echo "Installing Cypress version $version"

    wget --no-verbose -O /tmp/cypress.zip "https://cdn.cypress.io/desktop/$version/linux-x64/cypress.zip"

    export CYPRESS_INSTALL_BINARY="/tmp/cypress.zip" 

    npm install -g cypress@$version

    # Remove Cypress zip after installation
    rm /tmp/cypress.zip
    unset CYPRESS_INSTALL_BINARY

    # Prevent future Cypress installations from re-downloading binary
    export CYPRESS_INSTALL_BINARY=0

    echo "Verifying Cypress installation"
    npx cypress info
}