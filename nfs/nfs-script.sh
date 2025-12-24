#! /bin/bash

#NFS Server

#Установка пакета для сервера
sudo apt install nfs-kernel-server && echo "1: OK" || echo "1: Failed"

#Создание папки и выдача необходимых прав
sudo mkdir -p /srv/share/upload && echo "2: OK" || echo "2: Failed"
sudo chown -R nobody:nogroup /srv/share && echo "3: OK" || echo "3: Failed"
sudo chmod 0777 /srv/share/upload && echo "4: OK" || echo "4: Failed"

#Добавление в конфигурацию сервера
echo "/srv/share 192.168.100.110/32(rw,sync,root_squash)" | sudo tee -a /etc/exports > /dev/null

#Проверка конфигурации
sudo exportfs -r && sudo exportfs -s && echo "5: OK" || echo "5: Failed"


#NFS Client

#Установка пакета для клиента
sudo apt install nfs-common && echo "1: OK" || echo "1: Failed"

#Добавление строки в для монтирования в fstab
echo "192.168.100.107:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" | sudo tee -a /etc/fstab /dev/null

#Перезапуск служб
sudo systemctl daemon-reload  && sudo systemctl restart remote-fs.target && echo "2: OK" || echo "2: Failed"




