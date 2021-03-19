#stop and disable firewalld and selinux
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
echo "add centos7 epel repository and installation"
yum install -y epel-release
echo "installation apache..."
sudo yum install -y httpd
echo "installation of the necessary software..."
sudo yum install -y nano
sudo yum install -y htop
sudo yum install -y wget
# copy and modify index.html
  sudo cp /usr/share/httpd/noindex/index.html "/var/www/html/"
  sudo sed -i "s/123/back2/g" "/var/www/html/index.html"
# enable and start apache
sudo systemctl enable httpd && sudo systemctl start httpd

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
echo "FINAL CHECK..."
sudo systemctl status filebeat
sudo systemctl status node_exporter.service
sudo systemctl status httpd
