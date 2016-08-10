#writes to hostfile
cd /home/vagrant/vhosts/
regex="([a-zA-Z0-9_-]*).conf"	
for filename in *.conf; do
	if [[ $filename =~ $regex ]]	
	then
		NAME="${BASH_REMATCH[1]}"
		sudo echo -en "\n127.0.0.1 $NAME.dev" >> "/etc/hosts"
	fi
done

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