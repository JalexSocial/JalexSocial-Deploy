#!/bin/bash

# NOTE: After initialization make sure to click the networking tab in Amazon Lightsail and open up an https port

# Update package list and upgrade all packages
apt update -y

apt install wget nginx certbot python3-certbot-nginx -y

wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

apt-get update && \
  apt-get install -y dotnet-sdk-6.0
  
apt-get install -y dotnet-sdk-7.0
  

mkdir /var/jalexweb  
cd /var/jalexweb
git clone https://github.com/JalexSocial/jalexsocial-deploy
chown -R ubuntu:ubuntu /var/jalexweb

cp /var/jalexweb/jalexsocial-deploy/lightsail/ubuntu/scripts/services/jalexweb.service /etc/systemd/system/
cp /var/jalexweb/jalexsocial-deploy/lightsail/ubuntu/scripts/nginx/sites-available/* /etc/nginx/sites-available

ln -s /etc/nginx/sites-available/jalexweb /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

systemctl enable jalexweb
systemctl enable nginx

mkdir /var/www/jalexweb
chown ubuntu /var/www/jalexweb

chmod 755 /var/jalexweb/jalexsocial-deploy/lightsail/ubuntu/scripts/certbot/install-certbot.sh

certbot --nginx --non-interactive --agree-tos --redirect -m mike@logic-gate.com -d dev.jalex.io

# Enable firewall
apt-get install ufw

ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

ufw enable

