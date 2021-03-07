Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
     config.vbguest.auto_update = false
  end


  config.vm.define "front", primary: true do |front|
    front.vm.hostname = "front"
    front.vm.box = "centos/7"
    front.vm.box_version = "2004.01"
    front.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
    front.vm.network "private_network", ip: "192.168.11.100"
    front.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    #front.vm.provision "shell", path: "скрипт для установки и настройки nginx+node_exporter"
  end

  config.vm.define "back1", primary: true do |back1|
      back1.vm.hostname = "back1"
      back1.vm.box = "centos/7"
      back1.vm.box_version = "2004.01"
      back1.vm.network "forwarded_port", guest: 80, host: 8081, host_ip: "127.0.0.1"
      back1.vm.network "private_network", ip: "192.168.11.101"
      back1.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
    end
    #back1.vm.provision "shell", path: "скрипт для установки и настройки apache+node_exporter"
  end

  config.vm.define "back2", primary: true do |back2|
      back2.vm.hostname = "back2"
      back2.vm.box = "centos/7"
      back2.vm.box_version = "2004.01"
      back2.vm.network "forwarded_port", guest: 80, host: 8082, host_ip: "127.0.0.1"
      back2.vm.network "private_network", ip: "192.168.11.102"
      back2.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
    end
    #back2.vm.provision "shell", path: "скрипт для установки и настройки apache+node_exporter"
  end

  config.vm.define "mon", primary: true do |mon|
      mon.vm.hostname = "mon"
      mon.vm.box = "centos/7"
      mon.vm.box_version = "2004.01"
      mon.vm.network "forwarded_port", guest: 9090, host: 9090, host_ip: "127.0.0.1"
      mon.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1"
      mon.vm.network "private_network", ip: "192.168.11.103"
      mon.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
    end
    #mon.vm.provision "shell", path: "скрипт для установки и настройки prometheus+grafana+node_exporter"
  end

  config.vm.define "mas", primary: true do |mas|
      mas.vm.hostname = "mas"
      mas.vm.box = "centos/7"
      mas.vm.box_version = "2004.01"
      mas.vm.network "forwarded_port", guest: 80, host: 8083, host_ip: "127.0.0.1"
      mas.vm.network "private_network", ip: "192.168.11.104"
      mas.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
    end
    #mas.vm.provision "shell", path: "скрипт для установки и настройки sql server master+node_exporter"
  end

  config.vm.define "slave", primary: true do |slave|
      slave.vm.hostname = "slave"
      slave.vm.box = "centos/7"
      slave.vm.box_version = "2004.01"
      slave.vm.network "forwarded_port", guest: 80, host: 8084, host_ip: "127.0.0.1"
      slave.vm.network "private_network", ip: "192.168.11.105"
      slave.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
    end
    #slave.vm.provision "shell", path: "скрипт для установки и настройки sql server slave+node_exporter"
  end


end
