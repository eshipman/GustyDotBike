#!/bin/bash

WORDPRESS_CONFIG="./wordpress.tar.gz"

# Install the dependencies
sudo apt-get update
sudo apt-get -y install apache2 mysql-server php libapache2-mod-php php-mysql \
    php-curl php-gd php-mbstring php-xml php-xmlrpc openjdk-8-jre

# Verify apache is running
sudo systemctl start apache2

JAVA_PATH="/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java"

# Download the Mooshak installer
wget http://mooshak2.dcc.fc.up.pt/install/MooshakInstaller.jar

# Run the installer with the correct version of Java
sudo "${JAVA_PATH}" -jar MooshakInstaller.jar -cui <<EOF










EOF

# Install wordpress

# the user must be a sudoer
# sudo chown -R user:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins
