# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir       = File.dirname(File.expand_path(__FILE__))
configs           = YAML.load_file("#{current_dir}/config.yml")
machine_config    = configs['machines']
vbox_image_config = configs['vbox_image']

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
        current_machine_config = machine_config['NODE1']
        
        machine.vm.box = vbox_image_config['name']
        machine.vm.hostname = current_machine_config['hostname']

        machine.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 500,
                "--cpus", 1,
                "--cpuexecutioncap", "100"
            ]
        end

        machine.vm.network "private_network", ip: current_machine_config['ip_address']
        machine.vm.network "forwarded_port", guest: 22, host: 10022

        machine.vm.provision "shell", inline: "echo Finished machine NODE1 creation!"
    end

    ###############################################################################################
    #                                   NODE 2
    #
    # Port Range: 20000 ... 29999
    #
    config.vm.define "NODE2", primary: true do |machine|
        current_machine_config = machine_config['NODE2']

        machine.vm.box = vbox_image_config['name']
        machine.vm.hostname = current_machine_config['hostname']

        machine.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 500,
                "--cpus", 1,
                "--cpuexecutioncap", "100"
            ]
        end

        machine.vm.network "private_network", ip: current_machine_config['ip_address']
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
        current_machine_config = machine_config['NODE2']

        machine.vm.box = vbox_image_config['name']
        machine.vm.hostname = current_machine_config['hostname']

        machine.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 500,
                "--cpus", 1,
                "--cpuexecutioncap", "100"
            ]
        end

        machine.vm.network "private_network", ip: current_machine_config['ip_address']
        machine.vm.network "forwarded_port", guest: 22, host: 50022

        ###########################################################################################
        # copy the private-keys of all vagrant users (of all nodes) to vagrant@management
        # .ssh folder (/home/vagrant/.ssh).
        #
        machine.vm.provision "ansible_local" do |ansible|
            # ansible should be installed automatically 
            #   ... you need Vagrant >= 1.8.4 (see https://github.com/mitchellh/vagrant/issues/6858)
            ansible.install  = true
        
            ansible.inventory_path = "/vagrant/management/ansible/hosts"
            ansible.limit = "management"

            ansible.provisioning_path = "/vagrant/management/ansible"
            ansible.playbook = "prepare-management-infrastructure.yml"
           
            ansible.verbose = true
        end        

        ###########################################################################################
        # setup ALL managed nodes
        #
        machine.vm.provision "ansible_local" do |ansible|
            ansible.inventory_path = "/vagrant/management/ansible/hosts"
            ansible.limit = "all"

            ansible.provisioning_path = "/vagrant/management/ansible"
            ansible.playbook = "setup.yml"
            
            ansible.verbose = true
        end        

        machine.vm.provision "shell", inline: "echo Finished machine MANAGEMENT setup and target system provisioning!"
    end

end
