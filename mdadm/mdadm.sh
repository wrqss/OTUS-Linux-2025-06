#! /bin/bash
set -e

#Создание рейда10 из четырех девайсов sdb,sdc,sdd,sde
mdadm --create --verbose /dev/md127 -l 10 -n 4 /dev/sd{b,c,d,e}

#Создание конфигурацинного файла  mdadm.conf
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

#Создание gpt раздела и разбиение на партишены
parted -s /dev/md127 mklabel gpt
parted /dev/md127 mkpart primary ext4 0% 25%
parted /dev/md127 mkpart primary ext4 25% 50%
parted /dev/md127 mkpart primary ext4 50% 75%
parted /dev/md127 mkpart primary ext4 75% 100%

#Создание файловой системы ext4 для ранее созданных партишенов
mksf.ext4 /dev/md127p1
mkfs.ext4 /dev/md127p1
mkfs.ext4 /dev/md127p2
mkfs.ext4 /dev/md127p3
mkfs.ext4 /dev/md127p4

#Создание каталогов для монтирования и монтирование
mkdir -p /raid/part{1,2,3,4}
for i in $(seq 1 4); do mount /dev/md127p$i /raid/part$i; done

set +e
