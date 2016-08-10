# Variables
DBHOST=localhost
#DBNAME=dbname
DBUSER=dewald
DBPASSWD=password

# MySQL setup for development purposes ONLY
echo -e "\n--- Setup MySQL ---\n"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install mysql-server phpmyadmin >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"
#mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME" >> /vagrant/vm_build.log 2>&1
#mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'" > /vagrant/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on *.* to '$DBUSER'@'%' identified by '$DBPASSWD'" > /vagrant/vm_build.log 2>&1


sudo -s
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
sed 's/bind-address\s*=\s127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/my.cnf > /etc/mysql/my.cnf.new
rm /etc/mysql/my.cnf
mv /etc/mysql/my.cnf.new /etc/mysql/my.cnf
service mysql restart
exit

#Move vhost files
function mysql_db_upload 
{
	cd /home/vagrant/databases/
	regex="([a-zA-Z0-9_]*)"	
	for filename in *.sql; do
		if [[ $filename =~ $regex ]]	
		then
			NAME="${BASH_REMATCH[1]}"
			exec "mysql --user=$DBUSER --host=$DBHOST --password=$DBPASSWD $NAME < $NAME.sql"
		fi
	done
}
mysql_db_upload

