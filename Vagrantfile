Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.dns.tld = "dev"

  config.vm.hostname = "machine"

  config.dns.patterns = [/^.*.dev$/, /^.*.dev$/]

  config.vm.network :private_network, ip: "33.33.33.60"
  config.vm.network :forwarded_port, guest: 3306, host: 3316

  config.vm.synced_folder "~/work/sites", "/Vagrant/public_html", type: "nfs"

  config.vm.provision "shell", path: "./provision/clean.sh"  
  config.vm.provision "shell", path: "./provision/boot.sh"  
  config.vm.provision "file", source: "./provision/vhosts", destination: "~/vhosts"
  config.vm.provision "shell", path: "./provision/hosts.sh"  
  config.vm.provision "file", source: "./provision/databases/", destination: "~/databases/"
  config.vm.provision "shell", path: "./provision/mysql.sh"
end
