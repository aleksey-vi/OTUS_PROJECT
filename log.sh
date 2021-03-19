# установка необходимого ПО и подготовка сервера
echo "installation of the necessary software..."
sudo yum install -y nano
sudo yum install -y htop
sudo yum install -y wget
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

### УСТАНОВКА и НАСТРОЙКА java
echo "Downloadind and installing java..."
sudo curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O 'http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm'
sudo rpm -ivh jdk-*
sudo java -version

### УСТАНОВКА и НАСТРОЙКА Elasticsearch

# скачиваем и устанавливаем Elasticsearch
echo "Downloading and installing Elasticsearch..."
sudo wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.3.2-x86_64.rpm
sudo rpm -ivh elasticsearch-*
# заставляем systemd перечитать имеющиейся таргеты и запускаем прометей
echo "Staring elasticsearch.service..."
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
sudo systemctl status elasticsearch

### УСТАНОВКА и НАСТРОЙКА Kibana

# скачиваем Kibana
echo "Downloading and installing kibana..."
sudo wget -q https://artifacts.elastic.co/downloads/kibana/kibana-7.3.2-x86_64.rpm
sudo rpm -ivh kibana-*
# скачиваем конфиг файл Kibana
sudo wget -q https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/kibana.yml
# копируем его в директорию
sudo cp kibana.yml /etc/kibana/
# добавляем в автозагрузку, запускаем и выводим статус сервиса Kibana
echo "Staring kibana..."
sudo systemctl enable kibana
sudo systemctl start kibana
sudo systemctl status kibana


### УСТАНОВКА и НАСТРОЙКА logstash

echo "Downloading and installing logstash..."
wget -q https://artifacts.elastic.co/downloads/logstash/logstash-7.3.2.rpm
rpm -ivh logstash-*
# скачиваем конфиг файлы logstash
sudo wget -q https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/input.conf
sudo wget -q https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/filter.conf
sudo wget -q https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/output.conf
# копируем их в директорию
sudo cp input.conf /etc/logstash/conf.d/
sudo cp filter.conf /etc/logstash/conf.d/
sudo cp output.conf /etc/logstash/conf.d/
# добавляем в автозагрузку, запускаем и выводим статус сервиса logstash
echo "Staring logstash..."
sudo systemctl enable logstash
sudo systemctl start logstash
sudo systemctl status logstash

### УСТАНОВКА и НАСТРОЙКА Filebeat

echo "Downloading and installing Filebeat..."
sudo wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.3.2-x86_64.rpm
rpm -ivh filebeat-*
# скачиваем конфиг файл Filebeat
sudo wget -q https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/filebeat.yml
# копируем в директорию
sudo cp filebeat.yml /etc/filebeat/
echo "Staring Filebeat..."
sudo systemctl enable filebeat
sudo systemctl start filebeat
sudo systemctl status filebeat
