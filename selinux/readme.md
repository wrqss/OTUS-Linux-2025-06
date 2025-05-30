#### Запуск nginx несколькими способами на порту 4881

##### 1. Способ с помощью setsebool
   Поиск времени возникновения проблемы и способ решения
   
   **grep -i 4881 /var/log/audit/audit.log**
`type=AVC msg=audit(1748555530.572:1001): avc:  denied  { name_bind } for  pid=5970 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0`
`type=AVC msg=audit(1748555536.921:1005): avc:  denied  { name_bind } for  pid=5987 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0`
`type=AVC msg=audit(1748593884.549:1075): avc:  denied  { name_bind } for  pid=6473 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0`


[root@selinux ~]# **grep 1748593884.549:1075 /var/log/audit/audit.log | audit2why**
`type=AVC msg=audit(1748593884.549:1075): avc:  denied  { name_bind } for  pid=6473 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0`

        Was caused by:
        The boolean nis_enabled was set incorrectly.
        Description:
        Allow nis to enabled

        Allow access by executing:
        # setsebool -P nis_enabled 1
        


setsebool — это утилита для управления политиками SELinux (Security-Enhanced Linux).
nis_enabled — это SELinux boolean-переменная, которая разрешает или запрещает использование NIS (Network Information Service, также известного как Yellow Pages) в системе.
on — включает переменную (разрешает).
-P — делает изменение постоянным (сохраняется после перезагрузки).


![image](https://github.com/user-attachments/assets/85e81873-b9f1-43a9-8c4d-01ec2f61d221)

##### 2. Способ с помощью semanage

semanage позволяет настраивать и изменять политики SELinux без необходимости вручную редактировать файлы политик.
С помощью этой команды можно управлять:
портами (какие службы могут слушать какие порты)
контекстами файлов и каталогов
контекстами пользователей и ролей
контекстами интерфейсов и сетевых объектов

![image](https://github.com/user-attachments/assets/c6193196-c37a-4cc0-b62d-8b9144214cdd)

##### 3. Способ с помощью semodule

semodule позволяет:
устанавливать (загружать) новые модули политики SELinux,
удалять (выгружать) модули,
обновлять и управлять ими,
просматривать список установленных модулей.
Модули политики SELinux — это расширения или изменения стандартной политики безопасности, которые позволяют добавлять новые правила или изменять существующие без полной пересборки всей политики.

Данный способо включает в себя формирование и установки модуля для nginx 
![image](https://github.com/user-attachments/assets/80273d05-f7aa-4bc5-bb82-4fc94c1bd5d7)


#### Обеспечение работоспособности приложения при включенном SELinux

Развернут стенд с помощью Vagrant с двумя ВМ. Подключившись к ВМ client, и попробовав внести изменения в зону, получаем ошибку update failed: SERVFAIL.

Изучив логи SELinux на сервере ns01, что ошибка в контексте безопасности. Целевой контекст named_conf_t. У наших конфигов в /etc/named вместо типа named_zone_t используется тип named_conf_t. Тут мы также видим, что контекст безопасности неправильный. Проблема заключается в том, что конфигурационные файлы лежат в другом каталоге.

Необходимо тип контекста безопасности для каталога /etc/named. После изменения контекеста, удается внести изменения на стороне клиента


![image](https://github.com/user-attachments/assets/a0737fb5-68ae-432b-bee0-8c20edfc5b03)

