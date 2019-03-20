#!/bin/bash

JAVA_PATH="/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java"

# Install the dependencies
sudo apt-get install apache2 openjdk-8-jre

# Download the Mooshak installer
wget http://mooshak2.dcc.fc.up.pt/install/MooshakInstaller.jar

# Run the installer with the correct version of Java
"${JAVA_PATH}" -jar MooshakInstaller.jar <<EOF
0
yes






EOF
