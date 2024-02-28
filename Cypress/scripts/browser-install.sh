#!/bin/sh

while getopts ":c:f:e:z:" flag
do
    case "${flag}" in
        c)  chrome_version=${OPTARG};;
        f)  firefox_version=${OPTARG};;
        e)  edge_version=${OPTARG};;
        v)  cypress_versions=${OPTARG};;
    esac
done

# Chrome
if [ ! -z "$chrome_version" ]; then
    echo "Installing Chrome version $chrome_version";
    
    wget --no-verbose -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_$chrome_version-1_amd64.deb" && \
    dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
    apt-get install -f -y && \
    rm -f /usr/src/google-chrome-stable_current_amd64.deb

    echo "Installation complete";
else
    echo "Skipping Chrome installation";
fi

# Firefox
if [ ! -z "$firefox_version" ]; then
    echo "Installing Firefox dependencies"

    apt-get update && apt-get install -y bzip2 mplayer && rm -rf /var/lib/apt/lists/* && apt-get clean

    echo "Installing Firefox version $firefox_version";
    
    wget --no-verbose -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$firefox_version/linux-x86_64/en-GB/firefox-$firefox_version.tar.bz2" && \
    tar -C /opt -xjf /tmp/firefox.tar.bz2 && \
    rm /tmp/firefox.tar.bz2 && \
    ln -fs /opt/firefox/firefox /usr/bin/firefox

    echo "Installation complete";
else
    echo "Skipping Firefox installation";
fi

# Edge
if [ ! -z "$edge_version" ]; then
    echo "Installing Edge dependencies"
    apt-get update && apt-get install -y  gnupg dirmngr && rm -rf /var/lib/apt/lists/* && apt-get clean

    echo "Installing Edge version $edge_version";
    
    wget --no-verbose -O /usr/src/microsoft-edge-stable_amd64.deb "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_$edge_version-1_amd64.deb" && \
    dpkg -i /usr/src/microsoft-edge-stable_amd64.deb ; \
    apt-get install -f -y && \
    rm -f /usr/src/microsoft-edge-stable_amd64.deb

    echo "Installation complete";
else
    echo "Skipping Edge installation";
fi

# Cypress install script
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