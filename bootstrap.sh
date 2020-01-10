#!/usr/bin/env bash

sudo dnf upgrade

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

sudo dnf module install php:remi-7.3 -y

sudo dnf install mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb
# sudo mysql_secure_installation

sudo dnf install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

sudo dnf install git npm -y
sudo dnf install nano mc -y

sudo usermod -a -G nginx vagrant
sudo chown -R vagrant:nginx /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

