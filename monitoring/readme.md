#### На ВМ развертута связка prometheus + grafana.

1. prometheus устанавливается скриптом prometehus-install.sh
2. Создаем prometheus.service
3. Пакет grafana скачивается с официального сайта и устанавливается через dpkg -i .
4. В конфигурации /etc/prometheus/prometheus.yml добавляется запись для нужного нам сервера

#### Настройка node-exporter

1. Устанавливается скриптом node-exporter.sh на сервер, который планируем мониторить

#### Настройка Grafana

1. Необходимо зайти на веб версию графаны, в разеделе Connections добавить уже установленный prometheus
2. Создать дашборд для мониторинга сервера, путем ипорта интересующего нас дашборда. Например, ID 15172

#### Дашборд моего proxmox гипервизора

![image](https://github.com/user-attachments/assets/71778562-7c8d-4db0-8f43-aa09058910c4)

