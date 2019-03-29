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
ROOT_PASSWORD=""
MYSQL_PASSWORD=""
USER=""

read -p "Enter your mySQL root password: " ROOT_PASSWORD
read -p "Enter your wordpressuser MYSQL Password: " MYSQL_PASSWORD
read -p "Enter your current sudo username (default is ubuntu on AWS): " USER 

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
# configure mysql
sudo mysql_secure_installation <<EOF

y
$ROOT_PASSWORD
$ROOT_PASSWORD
y
y
y
y
EOF

sudo echo  "<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" > /etc/apache2/mods-enabled/dir.conf

#restart apache
sudo systemctl restart apache2
#print the status for logs
sudo systemctl status apache2

# Install wordpress
sudo echo "
<Directory /var/www/html/>
AllowOverride All
</Directory>" >> /etc/apache2/apache2.conf

sudo a2emod rewrite

sudo apache2ctl configtest

sudo systemctl restart apache2
# unzip the wordpress config to html
tar -xvzf "$WORDPRESS_CONFIG" -C /var/www/html

sudo mysql -u root --password="${ROOT_PASSWORD}" -e "
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;"

# the user must be a sudoer
 sudo chown -R ubuntu:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins
sudo echo "$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)" >> /var/www/html/wp-config.php
sudo echo "
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', '$MYSQL_PASSWORD');

define('FS_METHOD', 'direct');" >> /var/www/html/wp-config.php


