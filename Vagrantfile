# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  $script = <<-SCRIPT
#!/bin/bash
sudo bash -c 'echo example.com > /etc/hostname'
echo -e "\ndeb http://download.opensuse.org/repositories/home:/rtCamp:/EasyEngine/xUbuntu_14.04/ /" >> /etc/apt/sources.list.d/ee-repo.list
gpg --keyserver "hkp://pgp.mit.edu" --recv-keys '3050AC3CD2AE6F03'
gpg -a --export --armor '3050AC3CD2AE6F03' | apt-key add -
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confmiss" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install nginx-ee nginx-custom
add-apt-repository -y 'ppa:ondrej/php'
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confmiss" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php5.6-fpm
wanttochange="listen = /var/run/php5-fpm.sock"
mkdir -p /var/www/example.com/htdocs
sudo cp -r /vagrant/index.php /var/www/example.com/htdocs/
chown -R www-data: /var/www/
cp -r /vagrant/example.com /etc/nginx/sites-available/example.com
ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
rm -r /etc/nginx/sites-enabled/default
service nginx restart
service php5.6-fpm restart
SCRIPT

# Ubuntu 14.04 64 bit
config.vm.define "app" do |trusty_app|
  trusty_app.vm.provider "virtualbox" do |v|
      v.memory = 1024
  end
  trusty_app.vm.box = "ubuntu/trusty64"
  trusty_app.vm.network "forwarded_port", guest: 80, host: 83
  trusty_app.vm.network "private_network", ip: "192.168.33.124"
  trusty_app.ssh.forward_agent = true
  trusty_app.vm.provision "shell", inline: $script
end

$script_health_check = <<-SCRIPT
sudo apt-get clean
sudo apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confmiss" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install mailutils
sudo mkdir ~/bin
sudo cp -r /vagrant/server_monitor.sh ~/bin/
chmod +x ~/bin/server_monitor.sh
bash ~/bin/server_monitor.sh &
SCRIPT

config.vm.define "monitor" do |trusty_monitor|
  trusty_monitor.vm.provider "virtualbox" do |v|
      v.memory = 1024
  end
  trusty_monitor.vm.box = "ubuntu/trusty64"
  trusty_monitor.vm.network "forwarded_port", guest: 80, host: 84
  trusty_monitor.vm.network "private_network", ip: "192.168.33.125"
  trusty_monitor.ssh.forward_agent = true
  trusty_monitor.vm.provision "shell", inline: $script_health_check
end
end
