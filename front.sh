#stop and disable firewalld and selinux
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
echo "add centos7 epel repository and installation..."
yum install -y epel-release
echo "installation nginx..."
sudo yum install -y nginx
echo "installation of the necessary software..."
sudo yum install -y nano
sudo yum install -y htop
sudo yum install -y wget
# generate nginx config
nginxConfPath="/etc/nginx/conf.d/upstream.conf"
echo "upstream httpd {" > $nginxConfPath
echo "server 192.168.11.101:80;" >> $nginxConfPath
echo "server 192.168.11.102:80;" >> $nginxConfPath
echo "}" >> $nginxConfPath
# enable reverse proxy
sed -i 's/location \/ {/location \/ { proxy_pass http:\/\/httpd;/g' /etc/nginx/nginx.conf
echo "enable and start nginx"
systemctl enable nginx && sudo systemctl start nginx
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
sudo systemctl status node_exporter.service
echo "Enabling node_exporter.services"
sudo systemctl enable node_exporter.service
