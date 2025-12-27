1. ВМ разворачиваем с помощью Vagrantfile

2. Устанавливаем knockd на inetRouter и centralRouter

3. Добавляем конфигурацию /etc/knockd.conf на inetRouter

4. Так же на inetRouter добавляем правила iptables_rules.ipv4. Сохранение правил и их включение после перезагрузки реализовано с помощью iptables-persistent
```
sudo apt install -y iptables-persistent
sudo systemctl enable --now netfilter-persistent

sudo install -m 600 /etc/iptables_rules.ipv4 /etc/iptables/rules.v4
sudo netfilter-persistent reload
```
5. Проверяем работоспособность knockd попыткой C centralRouter пытаемся подключиться к inetRouter по ssh 
<img width="1130" height="164" alt="image" src="https://github.com/user-attachments/assets/0ce5810a-9c72-4728-aa5e-861d02f59710" />

6. Устанавливаем nginx на centralServer

```
systemctl status nginx.service
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2025-12-27 13:26:36 UTC; 22s ago
       Docs: man:nginx(8)
    Process: 4809 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 4810 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 4903 (nginx)
      Tasks: 2 (limit: 710)
     Memory: 4.7M
        CPU: 25ms
     CGroup: /system.slice/nginx.service
             ├─4903 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             └─4906 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""

Dec 27 13:26:36 centralServer systemd[1]: Starting A high performance web server and a reverse proxy server...
Dec 27 13:26:36 centralServer systemd[1]: Started A high performance web server and a reverse proxy server.
```
7. На inetRouter2 необходимо отключить фаервол и включить форвардинг 
```
systemctl stop ufw
systemctl disable ufw
echo "net.ipv4.conf.all.forwarding = 1" >> /etc/sysctl.conf
```
8. Добавляем правила iptables-inetRouter2
9. Обращаясь к inetRouter2 с хостовой машины, получаем ответ от nginx

<img width="1136" height="674" alt="image" src="https://github.com/user-attachments/assets/096d2536-7c36-4f77-beaa-4ee32aa57f98" />



