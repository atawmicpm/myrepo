# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
  config.vm.define :pd do |pd|
    pd.vm.box = "precise32"
    pd.vm.hostname = "pd"
    pd.vm.network :forwarded_port, guest: 4567, host: 4567

    pd.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.provisioning_path = "/tmp/vagrant-chef"
      
      chef.add_recipe "pagerduty::apt"
      chef.add_recipe "rvm::system"
      chef.add_recipe "rvm::sinatra"
      chef.add_recipe "pagerduty::webapp"
    end
  end

end
