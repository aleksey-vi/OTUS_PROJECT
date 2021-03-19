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

#Установка и настройка node_exporter
echo "downloading node_exporter..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.1.1/node_exporter-1.1.1.linux-amd64.tar.gz
echo "Creaing user node_exporter"
sudo useradd --no-create-home --shell /bin/false node_exporter
echo "Extracting node_exporter-1.1.1.linux-amd64.tar.gz..."
sudo tar xfz node_exporter-*.t*.gz
echo "Copying node_exporter to /usr/local/bin..."
sudo cp node_exporter-1.1.1.linux-amd64/node_exporter /usr/local/bin/
echo "Changing owner of the /usr/local/bin/node_exporter"
sudo chown -v node_exporter /usr/local/bin/node_exporter
echo "Copying node_exporter.service"
wget https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/node_exporter.service
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service
echo "Starting node_exporter.service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter.service
echo "Enabling node_exporter.services"
sudo systemctl enable node_exporter.service

echo "FINAL CHECK..."
sudo systemctl status filebeat
sudo systemctl status node_exporter.service
sudo systemctl status logstash
sudo systemctl status kibana
sudo systemctl status elasticsearch
