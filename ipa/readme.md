# LDAP

## Задача:
- Установить FreeIPA
- Написать Ansible-playbook для конфигурации клиента

## Выполнение:
1. Стенд представляет из себя ВМ для ipa-server под управлением AlmaLinux и ipa-client под управлением Ubuntu
2. Установка FreeIPA сервера:

- Установим часовой пояс: 
```
timedatectl set-timezone Europe/Moscow
```
- Установим утилиту chrony:
```
dnf install -y chrony
```
- Запустим chrony и добавим его в автозагрузку: 
```
systemctl enable chronyd
```
- Выключим Firewall: 
```
systemctl stop firewalld
```
- Отключаем автозапуск Firewalld: 
```
systemctl disable firewalld
```
- Остановим Selinux: 
```
setenforce 0
```
- Поменяем в файле /etc/selinux/config, параметр Selinux на disabled:
```
vim /etc/selinux/config
```
```
SELINUX=disabled
```
- Для дальнейшей настройки FreeIPA нам потребуется, чтобы DNS-сервер хранил запись о нашем LDAP-сервере. В рамках данной лабораторной работы мы не будем настраивать отдельный DNS-сервер и просто добавим запись в файл /etc/hosts:
```
vim /etc/hosts
```
```
127.0.0.1   localhost localhost.localdomain 
127.0.1.1 ipa.otus.lan ipa
192.168.100.212 ipa.otus.lan ipa
```
- Устанавливаем FreeIPA сервер:
```
dnf install -y freeipa-server
```
- Запустим скрипт установки: 
```
ipa-server-install
```
После выполнения скрипта создаем пользователя otus-user
```
klist
Ticket cache: KCM:0
Default principal: admin@OTUS.LAN

Valid starting       Expires              Service principal
01/04/2026 15:38:20  01/05/2026 14:43:24  krbtgt/OTUS.LAN@OTUS.LAN
[root@ipa wrqs]#
[root@ipa wrqs]#
[root@ipa wrqs]# ipa user-add otus-user --first=Otus --last=User --password
Password:
Enter Password again to verify:
----------------------
Added user "otus-user"
----------------------
  User login: otus-user
  First name: Otus
  Last name: User
  Full name: Otus User
  Display name: Otus User
  Initials: OU
  Home directory: /home/otus-user
  GECOS: Otus User
  Login shell: /bin/sh
  Principal name: otus-user@OTUS.LAN
  Principal alias: otus-user@OTUS.LAN
  User password expiration: 20260104125305Z
  Email address: otus-user@otus.lan
  UID: 851400003
  GID: 851400003
  Password: True
  Member of groups: ipausers
  Kerberos keys available: True
```
  <img width="2812" height="1028" alt="image" src="https://github.com/user-attachments/assets/3215b73a-0fa3-46b3-b26d-70092d336702" />

Конфигурация сервера выполнена.

3. Конфигурация клиента выполним в помощью ansible-playbook ipa_client.yml
Проверим работоспособность с помощью выполнения команды 
```
kinit otus-user
```
При первом логине система запросит смену пароля

<img width="774" height="282" alt="image" src="https://github.com/user-attachments/assets/cbbcc039-95c5-4c6c-86aa-8d9e7cf6dd7d" />

