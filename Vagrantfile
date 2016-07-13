# -*- mode: ruby -*-
# vi: set ft=ruby :

###################################################################################################
# KEEP IN MIND:
# Vagrant is running the provisioning scripts per default as root-user - but not with an
# interactive shell. 
# THEREFORE: the current directory is the vagrant users home directory (e. g. /home/vagrant). 
# The provisioning scripts should NOT depend on the current directory (I recommend to use absolute
# paths).
#
Vagrant.configure(2) do |config|

    config.vm.synced_folder "./", "/vagrant", 
        id: "vagrant-root", owner: "vagrant", group: "vagrant", mount_options: ["dmode=755,fmode=755"]

    ###############################################################################################
    #                                   NODE 1
    #
    # Port Range: 10000 ... 19999
    #
    config.vm.define "NODE1", primary: true do |machine|
        machine.vm.box = "ubuntu/xenial64"
        machine.vm.hostname ="node1"

        machine.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 500,
                "--cpus", 1,
                "--cpuexecutioncap", "100"
            ]
        end

        machine.vm.network "private_network", ip: "192.168.1.10"
        machine.vm.network "forwarded_port", guest: 22, host: 10022

        machine.vm.provision "shell", inline: "echo Finished machine NODE1 creation!"
    end

    ###############################################################################################
    #                                   NODE 2
    #
    # Port Range: 20000 ... 29999
    #
    config.vm.define "NDOE2", primary: true do |machine|
        machine.vm.box = "ubuntu/xenial64"
        machine.vm.hostname ="node2"

        machine.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 500,
                "--cpus", 1,
                "--cpuexecutioncap", "100"
            ]
        end

        machine.vm.network "private_network", ip: "192.168.1.20"
        machine.vm.network "forwarded_port", guest: 22, host: 20022

        machine.vm.provision "shell", inline: "echo Finished machine NODE2 creation!"
    end

    ###############################################################################################
    #                         Management-Machine (the LAST machine!!!)
    #                   ... doing the provisioning via Ansible for ALL machines
    #
    # Port Range: 50000 ... 59999
    #       
    #
    config.vm.define "MANAGEMENT", primary: true do |machine|
        machine.vm.box = "ubuntu/xenial64"
        machine.vm.hostname ="management"

        machine.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 500,
                "--cpus", 1,
                "--cpuexecutioncap", "100"
            ]
        end

        machine.vm.network "private_network", ip: "192.168.1.50"
        machine.vm.network "forwarded_port", guest: 22, host: 50022

        ###########################################################################################
        # copy the private-keys of all vagrant users (of all nodes) to vagrant@management
        # .ssh folder (/home/vagrant/.ssh).
        #
        #### OPTION 1: working
        #
        machine.vm.provision "shell", path: "management/scripts/prepare-management-infrastructure.sh"
        #
        #### OPTION 2: preferred but NOT WORKING ... DONT KNOW WHY
        # 
        #           because thie error message:
        #               fatal: [management]: FAILED! 
        #                   => { "failed": true, 
        #                        "msg": "the file_name 
        #                           '/vagrant/.vagrant/machines/NODE1/virtualbox/private_key,' 
        #                           does not exist, or is not readable"
        #                      }
        #           ... but this file exists
        #   machine.vm.provision "ansible_local" do |ansible|
        #       # ansible should be installed automatically 
        #       #   ... you need Vagrant >= 1.8.4 (see https://github.com/mitchellh/vagrant/issues/6858)
        #       ansible.install  = true
        #
        #       ansible.limit = "management"
        #       ansible.provisioning_path = "/vagrant/management/ansible"
        #       ansible.playbook = "prepare-management-infrastructure.yml"
        #       ansible.inventory_path = "/vagrant/management/ansible/ansible-inventory"
        #    
        #       ansible.verbose = true
        #   end        

        ###########################################################################################
        # setup ALL managed nodes
        #
        machine.vm.provision "ansible_local" do |ansible|
            # ansible should be installed automatically 
            #   ... you need Vagrant >= 1.8.4 (see https://github.com/mitchellh/vagrant/issues/6858)
            ansible.install  = true
            
            ansible.provisioning_path = "/vagrant/management/ansible"
            ansible.inventory_path = "/vagrant/management/ansible/ansible-inventory"
            ansible.playbook = "setup.yml"
            ansible.limit = "all"
            
            ansible.verbose = true
        end        

        machine.vm.provision "shell", inline: "echo Finished machine MANAGEMENT setup and target system provisioning!"
    end

end
