# update sources
sudo apt update -y
echo "installation of the necessary software..."
sudo apt install -y nano
sudo apt install -y htop
sudo apt install -y wget
### УСТАНОВКА и НАСТРОЙКА Filebeat
echo "Downloading and installing Filebeat..."
sudo wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb
dpkg -i filebeat-*
# скачиваем конфиг файл Filebeat
sudo wget -q https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/filebeat.yml
# копируем в директорию
sudo cp filebeat.yml /etc/filebeat/
echo "Staring Filebeat..."
sudo systemctl enable filebeat
sudo systemctl start filebeat

# install mysql server 8.0.22
sudo apt install mysql-server-8.0 -y
# enable and start mysql service
systemctl is-enabled mysql.service || sudo systemctl enable mysql.service
systemctl is-active mysql.service || sudo systemctl start mysql.service
# [MASTER] Change bind address (sed: \t for tabulator)
sudo sed -i 's/bind-address\t\t= 127.0.0.1/bind-address\t\t= 192.168.11.104/g' /etc/mysql/mysql.conf.d/mysqld.cnf
# [MASTER] Create user for replication
sudo mysql -e "create user repl@192.168.11.105 IDENTIFIED WITH caching_sha2_password BY 'admin';"
sudo mysql -e "GRANT REPLICATION SLAVE ON *.* TO repl@192.168.11.105;"
# [MASTER] Restart mysql service
sudo systemctl restart mysql.service

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
sudo systemctl status mysql.service
