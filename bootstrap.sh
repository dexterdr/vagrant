#!/usr/bin/env bash

# Repositories & basic software
sudo dnf upgrade
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
sudo dnf install nano mc pwgen git npm -y

# PHP
sudo dnf module install php:remi-7.3 -y
sudo dnf install php-mysqlnd -y

# MariaDB
sudo dnf install mariadb-server -y
sudo systemctl enable mariadb
sudo cp /vagrant/configs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
sudo systemctl start mariadb

# NGINX
sudo dnf install nginx -y
sudo systemctl enable nginx
sudo cp /vagrant/configs/nginx.conf /etc/nginx/nginx.conf
sudo mkdir /etc/nginx/sites
sudo cp /vagrant/configs/site.conf.example /etc/nginx/sites/site.conf.example
sudo systemctl start nginx

# Setup of /var/www folder
sudo rm -rf /var/www/*
sudo usermod -a -G nginx vagrant
sudo chown -R vagrant:nginx /var/www
sudo chmod 2775 /var/www

# phpMyAdmin
wget -nv https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz
tar -zxf phpMyAdmin-4.9.4-english.tar.gz
rm phpMyAdmin-4.9.4-english.tar.gz
sudo mv phpMyAdmin-4.9.4-english /usr/share/phpMyAdmin
sudo mkdir /usr/share/phpMyAdmin/tmp
sudo chown -R vagrant:nginx /usr/share/phpMyAdmin/tmp
sudo chmod 2775 /usr/share/phpMyAdmin/tmp
sudo cp -pr /usr/share/phpMyAdmin/config.sample.inc.php /usr/share/phpMyAdmin/config.inc.php
sudo echo "\$cfg['TempDir'] = '/tmp';" >> /usr/share/phpMyAdmin/config.inc.php
sudo echo "\$cfg['blowfish_secret'] = '$(pwgen 32)';" >> /usr/share/phpMyAdmin/config.inc.php
sudo mysql < /usr/share/phpMyAdmin/sql/create_tables.sql
sudo ln -s /usr/share/phpMyAdmin /usr/share/nginx/html

# mysql_secure_installation
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root';"
sudo mysql -e "DELETE FROM mysql.user WHERE User = '';"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "FLUSH PRIVILEGES;"


