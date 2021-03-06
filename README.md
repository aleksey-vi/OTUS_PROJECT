# OTUS ДЗ ПРОЕКТНАЯ РАБОТА

## Домашнее задание
----------------------------------------
Цель:
Собрать воедино все знания и умения полученные в процессе прохождения курса.

- создать репозитории в GitHub (конфиги, скрипты, cron файлы и т.д.)
- настроить вебсервер с балансировкой нагрузки
- настроить MySQL репликацию (master-slave)
- установить CMS (на выбор: jumla/wordpress/wiki...)
- написать скрипт для бэкапа БД со slave сервера (потаблично с указанием позиции бинлога, скрипт хранить в GitHub)
- настроить систему мониторинга (конфиги хранить в GitHub)
- разработать план аварийного восстановления (на основании скриптов, конфигов, cron файлов и бэкапов в максимально короткие сроки настроить новый сервер "с нуля")
- продемонстрировать аварийное восстановление (на чистом сервере за короткий промежуток времени получить полностью настроенную рабочую систему)
--------------------------------------------------
### Выполнение
----------------------------------------------------------
Для запуска достаточно просто скачать себе на локальный ПК скрипт Install.sh и начать его выполнение.
После чего, будет выполнена развертывание инфраструктуры.

### Системные требования для развертывания инфраструктуры:
Минимальные системные требования необходимые для развертывания инфраструктуры - 30 гб пространства на жестком диске и 12 гб ОЗУ

### Инфраструктура:
Один сервер Nginx в качестве фронта, в Vagrantfile указан под именем FRONT \
Два серверa Apache c балансировкой нагрузки в качестве бек энда, в Vagrantfile указаны под именами Back1 и Back2\
Один сервер с базой данных, как основной, в Vagrantfile указан под именем Master \
Один сервер с базой данных, как запасной, в Vagrantfile указан под именем Slave (дополнительно на данном сервере\ находится скрипт для выполнения backup'a)\
Один сервер для систем мониторинга, в Vagrantfile указан под именем Mon \
Один сервер для системы сбора и хранения логов, в Vagrantfile указан под именем Log

### Структура репозитория

В репозитории хранятся:

-------------

- Vagrantfile в котором описана конфигурация всех виртуальных машин запускаемых в рамках проекта, а так же описаны запуски скриптов.
-----------------
- Install.sh - скрипт для автоматизированного запуска всего проекта.
----------
- front.sh - скрипт для запуска и настройки фронта(Nginx).
----------
- back1.sh - скрипт для запуска и настройки бекэнда(Apache).
----------
- back2.sh - скрипт для запуска и настройки бекэнда(Apache).
--------------
- backup.sh - скрипт для создания бекапов БД.
-------------
- log.sh - скрипт для запуска и настройки систем мониторинга(Elasticsearch, Logstash, Kibana, Filebeat).
------------
- master_provision.sh - скрипт для запуска и настройки БД mysql-server.
-----------
- slave_provision.sh - скрипт для запуска и настройки БД mysql-server для бекапов
---------------
- mon.sh - скрипт для запуска и настройки систем мониторинга (prometheus+grafana+node_exporter)
-------------
- filebeat.yml - файл конфигурации клиентского ПО для сбора логов
-------------
- filter.conf - необходим для сбора логов
-------------
- input.conf - необходим для сбора логов
-------------
- kibana.yml -файл конфигурации Kibana
-------------
- node_exporter.service - файл конфигурации клиентского ПО сбора метрик для системы мониторинга
-------------
- output.conf - необходим для сбора логов
-------------
- prometheus.service - файл для вызова сервисов prometheus
-------------
- prometheus.yml - файл конфигурации prometheus

### Домашние страницы:
http://localhost:3000/ - Grafana (log/pass admin:admin)\
http://localhost:8080/ - Apache \
http://192.168.11.106:5601/ - ELK
