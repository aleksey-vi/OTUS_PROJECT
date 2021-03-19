#!/bin/bash
# установка необходимого ПО
#if [[ $EUID -ne 0 ]]; then
#   echo "Этот скрипт должен запускать пользователем с root правами"
#   exit 1
#      else
      echo "Для запуска ПРОЕКТА у Вас должны быть установлены:VirtualBox и Vagrant.
Осуществляется проверка наличия необходимого ПО..."
sudo apt install -y git curl
#$1 = vagrant - поданая на вход скрипта переменная
      I=`dpkg -s vagrant | grep "Status" ` #проверяем состояние пакета (dpkg) и ищем в выводе его статус (grep)
      if [ -n "$I" ]; then echo "vagrant installed"
                      else
                      echo "vagrant not installed"
                      echo "Устанавливаем Vagrant..."
                      curl -O https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb && \
                      sudo dpkg -i vagrant_2.2.14_x86_64.deb
                      echo "then vagrant installed"
      fi
      j=`dpkg -l virtualbox | grep "Status" ` #проверяем состояние пакета (dpkg) и ищем в выводе его статус (grep)
      if [ -n "$j" ]; then
                      echo "virtualbox installed"
                      else
                      sudo apt update
                      sudo apt install virtualbox -y
                      echo "VirtualBox-6.1 installed"
      fi
    git clone https://github.com/aleksey-vi/OTUS_PROJECT.git
    cd OTUS_PROJECT
    vagrant up

#fi
