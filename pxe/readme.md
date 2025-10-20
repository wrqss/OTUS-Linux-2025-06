### Установка dnsmasq
1. Отключаем firewall

    ```
    systemctl stop ufw
    ```
    
    ```
    systemctl disable ufw
    ```
2. Устанавливаем dnsmasq. Добавляем конфигурацию 

     ```
     /etc/dnsmasq.d/pxe.conf
     ```
3. Создаем папку /srv/tftp и загружаем туда необходимые файлы
<img width="936" height="326" alt="image" src="https://github.com/user-attachments/assets/d0c5c59a-8278-41ed-a2f7-f1d5b8388b97" />


### Установка и настройка Apache
1.  Устанавливаем пакет пакет, создаем папку и скачиваем желаемый iso образ

   ``` 
     apt install apache2
     mkrid /srv/images
     cd /srv/images
     wget http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/noble-live-server-amd64.iso
   ```
2. Создаем файл и добавляем конфигурацию ks-server.conf

  ```
      /etc/apache2/sites-available/ks-server.conf
  ```
3. Включаем конфигурацию для apache
```
    a2ensite ks-server.conf
```
4. Вносим изменения в файл

```
/srv/tftp/amd64/pxelinux.cfg/default
```
5. Добавляем настройки для автоматической установки. Создаем папку, создаем конфигурацию

```
mkdir /srv/ks
vim /srv/ks/user-data
```

Для проверки работоспобности была создана дополнительная ВМ на гипервизоре и успешно разлита с помощью pxe

<img width="1646" height="678" alt="image" src="https://github.com/user-attachments/assets/ea22e6b0-1aad-4284-af05-43d6e416f227" />
