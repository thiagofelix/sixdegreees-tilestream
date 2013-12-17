# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "ubuntu-server-12042-x64"

  nodes = [
    { role: :tilestream, ip: '172.16.1.100', port: 8080 }
  ]

  nodes.each do |option|
    config.vm.define option[:role] do |node|
      node.vm.synced_folder "puppet/", "/home/vagrant/puppet"

      node.vm.provision :shell, path: "puppet/bootstrap.sh"
      node.vm.provision :shell,
        inline: "FACTER_ROLES=#{option[:role]} puppet apply --confdir puppet/ puppet/manifests/default.pp -vd"

      node.vm.network :private_network, ip: option[:ip]
      node.vm.network :forwarded_port, guest: 80, host: option[:port]

      node.vm.provider :virtualbox do |vb|
        vb.customize ['modifyvm', :id, '--memory', '256']
      end
    end
  end

end
