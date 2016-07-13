#!/bin/bash

###################################################################################################
# Ensure SSH-Connection to managed nodes via certificates ...
###################################################################################################
# copy private-keys of user vagrant to  ~/.ssh/ on the manegement machine and set permissions 
# correctly (600/700). We cannot use the scripts within 
#       /vagrant/.vagrant/machines/.../virtualbox/private_key
# directly because if the permissions.
#
if [ ! -d /home/vagrant/.ssh/ ]; then
   mkdir /home/vagrant/.ssh
   chmod 700 /home/vagrant/.ssh/
fi

cp /vagrant/.vagrant/machines/NODE1/virtualbox/private_key /home/vagrant/.ssh/private_key_NODE1
chmod 600 /home/vagrant/.ssh/private_key_NODE1
chown vagrant:vagrant /home/vagrant/.ssh/private_key_NODE1

cp /vagrant/.vagrant/machines/INBOUND/virtualbox/private_key /home/vagrant/.ssh/private_key_NODE2
chmod 600 /home/vagrant/.ssh/private_key_NODE2
chown vagrant:vagrant /home/vagrant/.ssh/private_key_NODE2

cp /vagrant/.vagrant/machines/MANAGEMENT/virtualbox/private_key /home/vagrant/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
