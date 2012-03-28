Vagrant::Config.run do |config|

  config.vm.define :mq do |mq_config|
    mq_config.vm.box = "centos5"
    mq_config.vm.box_url = 'http://puppetlabs.s3.amazonaws.com/pub/centos5_64.box'
    mq_config.vm.customize [
      "modifyvm", :id,
      "--name", "mq",
      "--memory", "512"
    ]
    mq_config.vm.network :hostonly, "33.33.33.10"
    mq_config.vm.share_folder ".", "/tmp/puppet", "."
    mq_config.vm.forward_port 22, 2222
    mq_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "mq.pp"
    end
  end
end
