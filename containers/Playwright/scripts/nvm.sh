#!/bin/bash
while getopts "n:" flag; do
  case "$flag" in
    n)  versions=$OPTARG;;
    *) echo "usage: $0 [-n] " >&2
    exit 1 ;;
  esac
done

# download nvm install script
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Check if the string is empty
if [ -z "$versions" ]; then
  versions = "20.11.1";
  echo "Node version not specified, default version node $versions will installed";
  exit 1;
else
  IFS=,
  # Read the string into an array
  read -ra array <<< "$versions"
  # Loop through the array elements
  for element in "${array[@]}"; do
    echo "Installing node $element";

    . ~/.nvm/nvm.sh && nvm install $element && nvm alias default $element && nvm use default

    echo "Installation complete";
  done

  # print installed node versions
  . ~/.nvm/nvm.sh && nvm list
fi