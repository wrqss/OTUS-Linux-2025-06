

# MySQL

## Задача:
- На мастере развернуть дамп базы bet.dmp  и настроить репликацию так, чтобы реплицировались таблицы:
bookmaker, competition, market, odds, outcome

Выполнено без использования Vagrant, на двух ВМ, развернутых на proxmox

1. Устанавливаем Percona Server for MySQL на master и slave:  

- Добавьте репозиторий Percona:
```
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
```
- Включите репозиторий PS-80:
```
sudo percona-release setup ps80
```
- Установите:
```
sudo apt update
sudo apt install -y percona-server-server
```
- Проверьте версию:
```
root@slave:/home/wrqs# mysql -V
mysql  Ver 8.0.44-35 for Linux on x86_64 (Percona Server (GPL), Release '35', Revision '20f82371')
```

2. Настраиваем Percona Server for MySQL на master:  

- Копируем конфиги в /etc/mysql/conf.d/

- Перезапускаем службу MySQL:
```
sudo systemctl restart mysql
```
- Подключаемся к mysql:
```
mysql -u root -p
```
- Проверяем атрибут server-id:
```
mysql> SELECT @@server_id;
+-------------+
| @@server_id |
+-------------+
|           1 |
+-------------+
```
- Убеждаемся что GTID включен:
```
mysql> SHOW VARIABLES LIKE 'gtid_mode';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| gtid_mode     | ON    |
+---------------+-------+
```
- Создадим тестовую базу bet и загрузим в нее дамп и проверим:

```
mysql> CREATE DATABASE bet;
Query OK, 1 row affected (0.03 sec)
```
```
mysql> exit
Bye
root@mysql:/home/wrqs# mysql -u root -p -D bet < bet.dmp
```
```
mysql> USE bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+------------------+
| Tables_in_bet    |
+------------------+
| bookmaker        |
| competition      |
| events_on_demand |
| market           |
| odds             |
| outcome          |
| v_same_event     |
+------------------+
7 rows in set (0.01 sec)
```
- Создадим пользователя для репликации и назначим ему права:
```
mysql> CREATE USER 'repl'@'%' IDENTIFIED BY '!OtusLinux2026';
Query OK, 0 rows affected (0.02 sec)

mysql> SELECT user,host FROM mysql.user where user='repl';
+------+------+
| user | host |
+------+------+
| repl | %    |
+------+------+
1 row in set (0.00 sec)

mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
Query OK, 0 rows affected (0.03 sec)

mysql> ALTER USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY '!OtusLinux2026';
Query OK, 0 rows affected (0.03 sec)

mysql> FLUSH PRIVILEGES;

Query OK, 0 rows affected (0.01 sec)
```
- Дампим базу для последующего залива на слэйв и игнорируем таблиц по заданию:
```
root@mysql:/home/wrqs# mysqldump --all-databases --triggers --routines --source-data=2 \
--ignore-table=bet.events_on_demand --ignore-table=bet.v_same_event \
-uroot -p > master.sql

```
и копируем на другую ВМ 
```
root@mysql:/home/wrqs# scp master.sql wrqs@192.168.100.213:/home/wrqs
```

3. Настраиваем Percona Server for MySQL на slave:
- Копируем конфиги из /vagrant/conf.d в /etc/mysql/conf.d/

- Правим в /etc/mysql/conf.d/01-base.cnf директиву server-id = 2
```
vim /etc/mysql/conf.d/01-base.cnf
```
- Раскомментируем в /etc/mysql/conf.d/05-binlog.cnf строки:
```
#replicate-ignore-table=bet.events_on_demand
#replicate-ignore-table=bet.v_same_event
```
```
vim /etc/mysql/conf.d/05-binlog.cnf
```
- Перезапускаем службу MySQL:
```
systemctl restart mysql
```
- Подключаемся к mysql:
```
mysql -u root -p
```
- Проверяем атрибут server-id:
```
mysql> SELECT @@server_id;
+-------------+
| @@server_id |
+-------------+
|           2 |
+-------------+
```
- Заливаем дамп мастера и убеждаемся что база есть и она без лишних таблиц:
```
mysql> SOURCE /vagrant/master.sql
```
```
mysql> SHOW DATABASES LIKE 'bet';
+----------------+
| Database (bet) |
+----------------+
| bet            |
+----------------+
1 row in set (0.01 sec)

mysql> USE bet;
Database changed
mysql> SHOW TABLES;
+---------------+
| Tables_in_bet |
+---------------+
| bookmaker     |
| competition   |
| market        |
| odds          |
| outcome       |
+---------------+
5 rows in set (0.00 sec)
```
- Запускаем слейв:
```
mysql> CHANGE MASTER TO MASTER_HOST = "192.168.100.104", MASTER_PORT = 3306, MASTER_USER = "repl", MASTER_PASSWORD = "!OtusLinux2026", MASTER_AUTO_POSITION = 1;
Query OK, 0 rows affected, 8 warnings (0.09 sec)

mysql> START SLAVE;
Query OK, 0 rows affected, 1 warning (0.16 sec)

mysql> SHOW SLAVE STATUS\G

*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: 192.168.100.104
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 240944
               Relay_Log_File: slave-relay-bin.000003
                Relay_Log_Pos: 120293
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table: bet.events_on_demand,bet.v_same_event
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 240944
              Relay_Log_Space: 121537
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 1
                  Master_UUID: bce16532-ebc1-11f0-a2bc-bc2411565a2f
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set: bce16532-ebc1-11f0-a2bc-bc2411565a2f:40-80
            Executed_Gtid_Set: 1708768e-ebc5-11f0-af30-bc2411dc3474:1,
bce16532-ebc1-11f0-a2bc-bc2411565a2f:1-80
                Auto_Position: 1
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
       Master_public_key_path:
        Get_master_public_key: 0
            Network_Namespace:
1 row in set, 1 warning (0.00 sec)
```
```
SHOW MASTER STATUS\G
*************************** 1. row ***************************
             File: mysql-bin.000002
         Position: 241260
     Binlog_Do_DB:
 Binlog_Ignore_DB:
Executed_Gtid_Set: bce16532-ebc1-11f0-a2bc-bc2411565a2f:1-81
1 row in set (0.00 sec)
```

6. Проверим репликацию: 
- На мастере:
```
mysql> USE bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> INSERT INTO bookmaker (id,bookmaker_name) VALUES(1,'1xbet');
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  1 | 1xbet          |
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)
```
- На слейве:
```
mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  1 | 1xbet          |
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.01 sec)
```  


- В binlog-ах на cлейве также видно последнее изменение, туда же он пишет информацию о GTID:


```
root@slave:/home/wrqs# mysqlbinlog /var/lib/mysql/ slave-relay-bin.000002
# The proper term is pseudo_replica_mode, but we use this compatibility alias
# to make the statement usable on server versions 8.0.24 and older.
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
mysqlbinlog: Error reading file '/var/lib/mysql/' (OS errno 21 - Is a directory)
ERROR: I/O error reading the header from the binary log
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
```
