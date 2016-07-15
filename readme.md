# Vagrant-Ansible-Integration
This project shows how to get started with vagrant multimachine images to build a complex solution that is provisioned by Ansible. This could be the groundwork to get started ... feel free to adapt it in the way you need it.

## How to use?

### Software Requirements
* Vagrant 1.8.4
* VirtualBox 5.x
* Internet connection

### Deployment
```
svn checkout git@github.com:mobi3006/de.cachaca.learn.vagrant-ansible.git
cd de.cachaca.learn.vagrant-ansible
vagrant up
```
After some minutes you should be able to use the application.

## What will be created?
Within the Vagrantfile currently two additional nodes (``NODE1``, ``NODE2``) are created (each representing a microservice). First, these machines are created and not provisioned. The ``MANAGEMENT''-node is the last one  created. Ansible is installed on ``MANAGEMENT`` automatically by Vagrant. It runs two [Ansible playbooks](https://mobi3006.gitbooks.io/pierreinside/content/ansible.html):

* ``prepare-management-infrastructure.yml`` - to finish the Ansible configuration
* ``setup.yml`` - to provision ALL machines within the solution

### Users created by Vagrant
Vagrant creates the user ``vagrant`` that has the following features

* ``sudo`` on any command is allowed without password
* a public-private-key (for ssh-connections) is created by Vagrant

Within this project we will not create any additional users.

### Certificates created by Vagrant
Vagrant creates (during ``vagrant up``) certificates for each machine's ``vagrant`` user (e. g. see ``.vagrant/machines/NODE1/virtualbox/private_key``). Each node is configured in a way that the created private key for that machine (this is key is machine-specific) can be used to login via certificate (``ssh vagrant@node1``).
In addition to this Vagrant default setup I configured the vagrant@MANAGEMENT user to be able to ssh to the ``vagrant`` users on the managed machines without password.

Ansible is based on ssh-connections and will use the generated ssh-keys to communicate with the managed nodes (see ``/etc/ansible/hosts``).
                                                     