# установка необходимого ПО
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

### УСТАНОВКА и НАСТРОЙКА GRAFANA

echo "Downloadind and installing grafana..."
wget -q https://dl.grafana.com/oss/release/grafana-7.4.2-1.x86_64.rpm
sudo yum install ./grafana-7.4.2-1.x86_64.rpm -y
# запускаем графану
echo "Starting grafana-server..."
sudo systemctl daemon-reload
sudo systemctl start grafana-server

### УСТАНОВКА и НАСТРОЙКА ПРОМЕТЕЯ
# скачиваем прометей
echo "Downloading prometheus..."
wget -q https://github.com/prometheus/prometheus/releases/download/v2.25.0/prometheus-2.25.0.linux-amd64.tar.gz
# добавляем пользователя для prometheus, от которого будет запускаться сам сервис прометея
# /sbin/nologin чтобы под пользователем нельзся было зайти
echo "Creating user prometheus..."
sudo useradd --no-create-home --shell /sbin/nologin prometheus
# создаем папки для хранения конфига и библиотек прометея
echo "Creating prometheus folders..."
mkdir /etc/prometheus
mkdir /var/lib/prometheus
# меняем владельца вышесозданных директорий на пользователя прометея
echo "Changing owner of the created prometheus folders..."
sudo chown -R prometheus: /etc/prometheus
sudo chown -R prometheus: /var/lib/prometheus
# распаковываем архив
echo "Extracting prometheus-2.25.0.linux-amd64.tar.gz"
sudo tar xfz prometheus-*.t*.gz
# копируем прометей
# -r рекурсивно, -v деталировано, -i интерактивно
# {console{_libraries,s},prometheus.yml} - перечисление
echo "Copying prometheus folders..."
sudo cp -rvi prometheus-2.25.0.linux-amd64/{console{_libraries,s},prometheus.yml} /etc/prometheus/
sudo cp prometheus-2.25.0.linux-amd64/prom{etheus,tool} /usr/local/bin
# меняем права директории prometheus
echo "Changing ownder of the created prometheus folders..."
sudo chown -v prometheus: /usr/local/bin/prom{etheus,tool}
sudo chown -R -v prometheus: /etc/prometheus/
# редактируем prometheus.yml
echo "Copying prometheus.yml..."
wget https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/prometheus.yml
sudo cp /home/vagrant/prometheus.yml /etc/prometheus/prometheus.yml
# Создаем юнит для systemd
echo "Copying prometheus.service..."
wget https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/prometheus.service
sudo cp /home/vagrant/prometheus.service /etc/systemd/system/prometheus.service
# заставляем systemd перечитать имеющиейся таргеты и запускаем прометей
echo "Staring prometheus.service..."
sudo systemctl daemon-reload
sudo systemctl start prometheus.service


### УСТАНОВКА и НАСТРОЙКА NODE_EXPORTER

# скачиваем node_exporter
# источник: https://prometheus.io/download/
echo "Downloading node_exporter..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.1.1/node_exporter-1.1.1.linux-amd64.tar.gz
# добавляем пользователя для node_exporter (/bin/false также ограничивает возможность логона указанного пользователя)
# пользователь node_exporter нужен для сбора информации и метрик
# /sbin/nologin == /bin/false
echo "Creaing user node_exporter..."
sudo useradd --no-create-home --shell /bin/false node_exporter
# распаковываем архив
echo "Extracting node_exporter-1.1.1.linux-amd64.tar.gz"
sudo tar xfz node_exporter-*.t*.gz
# копируем node_exporter в /usr/local/bin
echo "Copying node_exporter to /usr/local/bin"
sudo cp node_exporter-1.1.1.linux-amd64/node_exporter /usr/local/bin/
# меняем владельца node_exporter
echo "Changing owner of the /usr/local/bin/node_exporter"
sudo chown -v node_exporter /usr/local/bin/node_exporter
# создаём юнит для systemd для автозагрузки
echo "Copying node_exporter.service"
wget https://raw.githubusercontent.com/aleksey-vi/OTUS_PROJECT/main/node_exporter.service
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service
# запускаем свежесозданный сервис
echo "Starting node_exporter.service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter.service

# ДОБАВЛЕНИЕ СЕРВИСОВ В АВТОЗАГРУЗКУ

echo "Enabling services..."
sudo systemctl enable prometheus.service
sudo systemctl enable node_exporter.service
sudo systemctl enable grafana-server

echo "FINAL CHECK..."
sudo systemctl status filebeat
sudo systemctl status node_exporter.service
sudo systemctl status prometheus.service
sudo systemctl status grafana-server


echo "Добавьте дашборды, например № 11074 и 1860 "
