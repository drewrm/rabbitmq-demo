Vagrant::Config.run do |config|
  [{:name => :mq, :port => 2222, :ip => "33.33.33.10"},
   {:name => :ldap, :port => 2223, :ip => "33.33.33.11"}].each do |server|
    config.vm.define server[:name] do |config|
      config.vm.box = "centos5"
      config.vm.box_url = 'http://puppetlabs.s3.amazonaws.com/pub/centos5_64.box'
      config.vm.customize [
        "modifyvm", :id,
        "--name", server[:name].to_s,
        "--memory", "512"
      ]
      config.vm.network :hostonly, server[:ip]
      config.vm.share_folder ".", "/tmp/puppet", "."
      config.vm.forward_port 22, server[:port]
      config.vm.host_name = "#{server[:name].to_s}.vagrant.internal"
      config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.module_path = "modules"
        puppet.manifest_file = "#{server[:name].to_s}.pp"
      end
    end
  end
end
