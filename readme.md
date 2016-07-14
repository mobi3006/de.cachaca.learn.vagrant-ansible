# Vagrant-Ansible-Integration
This project shows how to get started with vagrant multimachine images to build a complex solution that is provisioned by Ansible.

## Overview
Within the Vagrantfile 1 .. n nodes of your solution are created (e. g. each representing a microservice). These machines are only created and not provisioned.

The last node created is the Management-Machine. Ansible is installed automatically by Vagrant and runs [Ansible playbooks](https://mobi3006.gitbooks.io/pierreinside/content/ansible.html) for provisioning of ALL machines within the solution (possibly also itself).

## Vagrants user creation
Vagrant creates the user "vagrant". Within this project we will use this user and not create additional ones.

## Vagrants certificate creation
Vagrant creates (during ``vagrant up``) certificates for each machine (e. g. see .vagrant/machines/NODE1/virtualbox/private_key). Each node is configured in a way that the created private key for that machine (this is key is machine-specific) can be used to login via certificate (``ssh vagrant@node1``).

## Ansible certificate usage
### General Recommendation
I would recommend to create a certificate for the management-user (maybe not "vagrant"). The private-key has to be put to ``/home/managementUser/.ssh/id_rsa@management-node`` (with 600 permissions) and the public-key has to be put to ``/home/remoteUser/.ssh/authorized_keys@managed-node`` for each managed node (the remoteUser is the one configured within your ansible scripts as ``remote_user: remoteUser`` ... maybe this is done within ``ansible.cfg``).

### Shortcut
I configured the private-keys created by Vagrant to be used by Ansible when sending commands via ssh to the managed nodes (see ansible-inventory). Because Vagrant has already allowed the ssh-connect with these private-certificates ... it works out-of-the-box. 

                                                     