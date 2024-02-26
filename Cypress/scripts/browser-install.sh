while getopts ":c:f:e:" flag
do
    case "${flag}" in
        c)  chrome_version=${OPTARG};;
        f)  firefox_version=${OPTARG};;
        e)  edge_version=${OPTARG};;
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