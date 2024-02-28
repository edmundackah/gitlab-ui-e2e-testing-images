# E2E Testing Docker images

This repo contains Dockerfiles and build scripts for creating Docker images for UI E2E testing. Currently only iamges for Cypress and Puppeteer are documented.

> **Note:** You will need to build the iamges yourself and host it in a container registry to use the images

## Shell scripts End of Line (EOL) sequence issues

When working on a shell script in a Windows environment, ensure the EOL for the file is set to `LF` to prevent unexpected errors when Docker runs the script in a Linux container.

[Click on this link](https://medium.com/@csmunuku/windows-and-linux-eol-sequence-configure-vs-code-and-git-37be98ef71df#:~:text=VS%20Code%20%3D%3E%20Settings%20%3D%3E,new%20files%20that%20you%20create.) to read about EOL sequence differences between Linux and Windows