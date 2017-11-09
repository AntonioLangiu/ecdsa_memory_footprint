$script = <<SCRIPT
sudo apt-get install -y git libtool autoconf automake pkg-config srecord valgrind
sudo apt-get install -y libtommath-dev
SCRIPT
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.provision "shell", inline: $script
end


