#writes to hostfile
sudo echo -en "\n127.0.0.1 delvv.dev" >> "/etc/hosts"


#Move vhost files
cd /home/vagrant/vhosts/
for filename in *.conf; do
	sudo mv "$filename" /etc/apache2/sites-available/$filename
done

#!/bin/bash
cd /etc/apache2/sites-available/
for filename in *.conf; do
	sudo a2ensite "$filename"
done

rm -r /home/vagrant/vhosts