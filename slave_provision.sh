# update sources
sudo apt update -y
echo "installation of the necessary software..."
sudo yum install -y nano
sudo yum install -y htop
sudo yum install -y wget
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


# [SLAVE] install ssh-passh for querying binlog file and position
sudo apt install sshpass -y
# install mysql server 8.0
sudo apt install mysql-server-8.0 -y
# enable and start mysql service
systemctl is-enabled mysql.service || sudo systemctl enable mysql.service
systemctl is-active mysql.service || sudo systemctl start mysql.service
# [SLAVE] Change server id on slave and restart mysql service
sudo sed -i 's/# server-id\t\t= 1/server-id\t\t= 2/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql.service
# [OPTIONAL][SLAVE] Make slave readonly
# Source: https://docs.j7k6.org/mysql-database-read-only/
sudo mysql -e "FLUSH TABLES WITH READ LOCK;"
sudo mysql -e 'SET GLOBAL read_only = 1'
# [SLAVE] add master fingerprint to known hosts
ssh-keyscan -H 192.168.11.104 >> /home/vagrant/.ssh/known_hosts
# [SLAVE] query current binlog on srvsql001
currentBinlogFile=$(sshpass -p 'vagrant' ssh vagrant@192.168.11.104 -o "StrictHostKeyChecking no" 'sudo mysql -e "show master status;" | grep binlog | cut -f1')
# [SLAVE] query current position on srvsql001
currentBinlogPosition=$(sshpass -p 'vagrant' ssh vagrant@192.168.11.104 -o "StrictHostKeyChecking no" 'sudo mysql -e "show master status;" | grep binlog | cut -f2')
# [SLAVE] Enable replication
sudo mysql -e "CHANGE MASTER TO MASTER_HOST='192.168.11.104', MASTER_USER='repl', MASTER_PASSWORD='admin', MASTER_LOG_FILE='$currentBinlogFile', MASTER_LOG_POS=$currentBinlogPosition, GET_MASTER_PUBLIC_KEY=1;"
# [SLAVE] Start replication
sudo mysql -e "START SLAVE;"
# wait 10 seconds to let slave sync
sleep 10
# [SLAVE] Show replication status
sudo mysql -e "show slave status\G;" | grep Slave_IO_State
sudo mysql -e "show slave status\G;" | grep Slave_SQL_Running_State
# Make the backup script executable
sudo chmod a+x /home/vagrant/backup.sh

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
