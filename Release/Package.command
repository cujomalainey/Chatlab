#!/bin/sh
# Builds the ChatLab Zips for distribution

clear

read -p "Version number: " version

# cd to the directory where this file is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

cd ..

mkdir Releases/$version

# First Copy
cp -R Release Releases/$version/ChatLab
# Remove the script from the directory
rm Releases/$version/ChatLab/Package.command

# Client Copy
cp -R Releases/$version/ChatLab Releases/$version/ChatLab-Client
rm -R Releases/$version/ChatLab-Client/Server
rm Releases/$version/ChatLab-Client/README-Server.md
rm Releases/$version/ChatLab-Client/LaunchServer.p

# Server Copy
cp -R Releases/$version/ChatLab Releases/$version/ChatLab-Server
rm -R Releases/$version/ChatLab-Server/Client
rm Releases/$version/ChatLab-Server/README-Client.md
rm Releases/$version/ChatLab-Server/LaunchClient.p

# Create the ZIPS
zip -m -r Releases/$version/ChatLab Releases/$version/ChatLab
zip -m -r Releases/$version/ChatLab-Client Releases/$version/ChatLab-Client
zip -m -r Releases/$version/ChatLab-Server Releases/$version/ChatLab-Server

read -n1 -r -p "Press any key to continue..." key