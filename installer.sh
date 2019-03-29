#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# If /var/www/html is not empty, warn the user
if [[ "$(ls -l /var/www/html)" != "total 0" ]]; then
    echo "Warning: this may erase any data in /var/www/html!"
    echo "It is recommended to back up any data first."
    read -p "Would you like to continue? (Y/n): " answer
    # Exit if the user inputs anything other than a yes
    if echo "${answer}" | grep -vE '^(Y|Yes|y|yes|YES)$' >/dev/null; then
        exit
    fi
fi

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

sudo mysql -u root --password="${SQL_ROOT_PASS}" -e "
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY '${SQL_USER_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY '${SQL_USER_PASS}';
FLUSH PRIVILEGES;"

# the user must be a sudoer
# sudo chown -R user:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins
