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
sudo systemctl status mysql.service
