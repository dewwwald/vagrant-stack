echo "----> Hello! Welcome to Ubuntu server 14.0.4!"
echo "lets make sure all is up to date..."


sudo echo -en "\nnameserver 8.8.8.8" >> "/etc/resolv.conf"
sudo echo -en "\nnameserver 8.8.4.4" >> "/etc/resolv.conf"

sudo apt-get update && sudo apt-get upgrade

echo "----> Installing LAMP"
echo "installing apache2..."
sudo apt-get install -yf apache2

sudo echo -en "\nKeepAlive Off\n" >> "/etc/apache2/apache2.conf"

# Enable this required module MPM
sudo echo -en "\n<IfModule mpm_prefork_module>\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"
sudo echo -en "\tStartServers            2\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"
sudo echo -en "\tMinSpareServers         6\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"
sudo echo -en "\tMaxSpareServers         12\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"
sudo echo -en "\tMaxRequestWorkers       39\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"
sudo echo -en "\tMaxConnectionsPerChild  3000\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"
sudo echo -en "</IfModule>\n" >> "/etc/apache2/mods-available/mpm_prefork.conf"

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo apt-get install -yf php5 libapache2-mod-php5
sudo a2enmod php5
sudo apt-get install -yf php5-mcrypt
sudo php5enmod mcrypt
sudo service apache2 restart

echo "installing MySQL..."
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get -y install mysql-server

echo "----> Setup mounted files"
#!/usr/bin/env bash
if ! [ -L /var/www/html/ ]; then
  rm -rf /var/www/html
  ln -fs /Vagrant/public_html /var/www/html
fi