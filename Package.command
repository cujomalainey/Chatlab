#!/bin/sh
# Builds the ChatLab Zips for distribution

clear

read -p "Version number: " version

# cd to the directory where this file is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

mkdir Releases/$version

# First Copy
cp -R Release Releases/$version/ChatLab

cd Releases/$version/

# Client Copy
cp -R ChatLab ChatLab-Client
rm -R ChatLab-Client/Server
rm ChatLab-Client/README-Server.md
rm ChatLab-Client/LaunchServer.p

# Server Copy
cp -R ChatLab ChatLab-Server
rm -R ChatLab-Server/Client
rm ChatLab-Server/README-Client.md
rm ChatLab-Server/LaunchClient.p

# Create the ZIPS
zip -m -r -X ChatLab ChatLab -x "*.DS_Store"
zip -m -r -X ChatLab-Client ChatLab-Client -x "*.DS_Store"
zip -m -r -X ChatLab-Server ChatLab-Server -x "*.DS_Store"

read -n1 -r -p "Press any key to continue..." key