# perform every step as root
# sudo su

# update sources
sudo apt update -y

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
