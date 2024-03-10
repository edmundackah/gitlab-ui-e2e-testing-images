#!/bin/bash
while getopts "b:" flag; do
  case "$flag" in
    b)  browsers=$OPTARG;;
    *) echo "usage: $0 [-v] [-r]" >&2
    exit 1 ;;
  esac
done

# Check if the string is empty
if [ -z "$browsers" ]; then
  echo "No browsers given. Expected comma separated list\n";
  echo "Expecting one of: chromium, chrome, chrome-beta, msedge, msedge-beta, msedge-dev, firefox, firefox-asan, webkit";
  exit 1;
else
  IFS=,
  # Read the string into an array
  read -ra array <<< "$browsers"
  # Loop through the array elements
  for element in "${array[@]}"; do
    echo "Installing $element";

    npx playwright install --with-deps $element

    echo "Installation complete";
  done
fi