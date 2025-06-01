# Создаем пользователя
 sudo useradd --no-create-home --shell /bin/false prometheus

# Создаем директории
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Скачиваем последнюю версию Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v3.4.1/prometheus-3.4.1.linux-amd64.tar.gz
tar xvf prometheus-*.linux-amd64.tar.gz
cd prometheus-*.linux-amd64.tar.gz


# Копируем бинарники
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

# Копируем конфиги
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus/prometheus.yml

# Устанавливаем владельца
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
