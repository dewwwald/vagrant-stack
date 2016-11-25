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

sudo apt-get install -yf php5 libapache2-mod-php5

sudo apt-get install python-software-properties software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update

sudo apt-get install php7.0 -yf
sudo a2enmod php7.0
sudo apt-get install php7.0-zip
sudo apt-get install php-gd

sudo apt-get install -yf php-mbstring php7.0-mbstring php-gettext
sudo apt-get install -yf php7.0-mysql
sudo echo 'extension=pdo.so' > /etc/php.ini

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork
sudo a2enmod rewrite
sudo a2enmod vhost_alias

sudo apt-get install -yf php7.0-mbstring
sudo phpenmod mbstring

# System requirements
sudo apt-get install -yf zip

# PHP plugins
sudo apt-get install -yf php7.0-mcrypt
sudo phpenmod mcrypt
sudo service apache2 restart

apt-get install -yf curl libcurl3 libcurl3-dev php5-curl
sudo service apache2 restart

sudo apt-get install -yf php5-intl
sudo service apache2 restart

# COMPOSER
mkdir "$HOME/.local"
mkdir "$HOME/.local/bin"

cd "$HOME/.local/bin"

echo PATH=$HOME/.local/bin:$PATH > ~/.bashrc

php -r "copy('https://getcomposer.org/installer', '~/.local/bin/composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

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