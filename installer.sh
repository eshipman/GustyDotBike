#!/bin/bash

# Install the dependencies
sudo apt-get -y install apache2 openjdk-8-jre

# Verify apache is running
sudo systemctl start apache2

JAVA_PATH="/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java"

# Download the Mooshak installer
wget http://mooshak2.dcc.fc.up.pt/install/MooshakInstaller.jar

# Run the installer with the correct version of Java
sudo "${JAVA_PATH}" -jar MooshakInstaller.jar -cui <<EOF










EOF
