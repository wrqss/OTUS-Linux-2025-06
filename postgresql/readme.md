### PostgreSQL

#### Настройка hot_standby репликации с использованием слотов

Перед настройкой репликации необходимо установить postgres-server на хосты node1 и node2:
1) Устанавливаем postgresql-server 16: `apt install postgresql postgresql-contrib`
2) Запускаем postgresql-server: `systemctl start postgresql`
3) Добавляем postgresql-server в автозагрузку:  `systemctl enable postgresql`


Далее приступаем к настройке репликации: 
На хосте node1: 
1. Заходим в psql и создаем пользователя

```
postgres=# CREATE USER replicator WITH REPLICATION Encrypted PASSWORD 'Otus2026!';
```

2. Правим конфигурацию:
```
vim /etc/postgresql/16/main/postgresql.conf
vim /etc/postgresql/16/main/pg_hba.conf
```
После изменения необходимо сделать рестарт демона

3. На node2 после установки postgresql необходимо почистить содержимое, чтобы не было конфликтов
```
root@slave:/home/wrqs# mv /var/lib/postgresql/16/main /var/lib/postgresql/16/main.bak.$(date +%F_%H%M%S)
root@slave:/home/wrqs# mkdir -p /var/lib/postgresql/16/main
root@slave:/home/wrqs# chown -R postgres:postgres /var/lib/postgresql/16/main
root@slave:/home/wrqs# chmod 700 /var/lib/postgresql/16/main
```
4. После этого, сможем с помощью утилиты pg_basebackup скопировать данные с  первой ноды
```
root@slave:/home/wrqs#  -u postgres pg_basebackup -h 192.168.100.104 -U replicator -D /var/lib/postgresql/16/main -R -P
```
5. Проверим репликацию, создадим БД на node1

```
postgres=# CREATE DATABASE otus_test;
CREATE DATABASE
postgres=# \|
invalid command \|
Try \? for help.
postgres=# \l
                                                       List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+------------+-----------+-----------------------
 otus_test | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |             |             |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |             |             |            |           | postgres=CTc/postgres
(4 rows)
```
Удостоверимся, что на 2й ноге база появилась

```
root@slave:/home/wrqs#  sudo -u postgres psql
psql (16.11 (Ubuntu 16.11-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# \l
                                                       List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+------------+-----------+-----------------------
 otus_test | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |             |             |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |             |             |            |           | postgres=CTc/postgres
(4 rows)
```
 Так же, с помощью команды  на мастере `select * from pg_stat_replication;`

 ```
  pid  | usesysid |  usename   |  application_name  |   client_addr   | client_hostname | client_port |         backend_start         | backend_xmin |   state   | sent_lsn  | write_lsn | flush_lsn | replay_lsn |   write_lag    |    flush_lag    |   replay_lag    | sync_priority | sync_state |          reply_time
-------+----------+------------+--------------------+-----------------+-----------------+-------------+-------------------------------+--------------+-----------+-----------+-----------+-----------+------------+----------------+-----------------+-----------------+---------------+------------+-------------------------------
 46337 |    16388 | replicator | 16/main            | 192.168.100.213 |                 |       33910 | 2026-01-08 09:19:40.576919-03 |              | streaming | 0/5000148 | 0/5000148 | 0/5000148 | 0/5000148  |                |                 |                 |             0 | async      | 2026-01-08 09:51:48.71536-03
 46389 |    16390 | barman     | barman_receive_wal | 192.168.100.107 |                 |       37806 | 2026-01-08 09:27:48.618268-03 |              | streaming | 0/5000148 | 0/5000148 | 0/5000000 |            | 00:00:02.97484 | 00:20:04.997648 | 00:23:55.486671 |             0 | async      | 2026-01-08 09:51:44.132932-03
(2 rows)
```
И на слейве `select * from pg_stat_wal_receiver;`

```
  pid  |  status   | receive_start_lsn | receive_start_tli | written_lsn | flushed_lsn | received_tli |      last_msg_send_time       |     last_msg_receipt_time     | latest_end_lsn |        latest_end_time        | slot_name |   sender_host   | sender_port |                                                                                                                                                                      conninfo                                                                          
-------+-----------+-------------------+-------------------+-------------+-------------+--------------+-------------------------------+-------------------------------+----------------+-------------------------------+-----------+-----------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 44966 | streaming | 0/3000000         |                 1 | 0/5000148   | 0/5000148   |            1 | 2026-01-08 12:52:48.737365+00 | 2026-01-08 12:52:48.735789+00 | 0/5000148      | 2026-01-08 12:36:48.394545+00 |           | 192.168.100.104 |        5432 | user=replicator password=******** channel_binding=prefer dbname=replication host=192.168.100.104 port=5432 fallback_application_name=16/main sslmode=prefer sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable
(1 row)
```

На этом настройка репликации завершена. 

В случае выхода из строя master-хоста (node1), на slave-сервере (node2) в psql необхоимо выполнить команду select pg_promote();
Также можно создать триггер-файл. Если в дальнейшем хост node1 заработает корректно, то для восстановления его работы (как master-сервера) необходимо: 
Настроить сервер node1 как slave-сервер
Также с помощью команды select pg_promote(); перевести режим его работы в master


#### Настройка резервного копирования

1. На хостах node1 и node2 необходимо установить утилиту barman-cli, для этого: 
Устанавливаем barman-cli: `apt install barman-cli`

2. На хосте barman выполняем следующие настройки: 
Устанавливаем пакеты barman и postgresql-client: `apt install barman-cli barman postgresql`

3. Переходим в пользователя barman и генерируем ssh-ключ: 
```
su barman
cd 
ssh-keygen -t rsa -b 4096
```

#### На хосте node1: 
Переходим в пользователя postgres и генерируем ssh-ключ: 
```
su postgres
cd 
ssh-keygen -t rsa -b 4096
```

После генерации ключа, выводим содержимое файла ~/.ssh/id_rsa.pub:
`cat ~/.ssh/id_rsa.pub `

Копируем содержимое файла на сервер barman в файл /var/lib/barman/.ssh/authorized_keys

4. В psql создаём пользователя barman c правами суперпользователя: 
```
CREATE USER barman WITH REPLICATION Encrypted PASSWORD 'Otus2026!';
GRANT EXECUTE ON FUNCTION pg_start_backup(text, boolean, boolean) TO barman;
GRANT EXECUTE ON FUNCTION pg_stop_backup()                       TO barman;
GRANT EXECUTE ON FUNCTION pg_stop_backup(boolean, boolean)       TO barman;

GRANT EXECUTE ON FUNCTION pg_switch_wal()               TO barman;
GRANT EXECUTE ON FUNCTION pg_create_restore_point(text) TO barman;
GRANT pg_read_all_settings TO barman;
GRANT pg_read_all_stats    TO barman;
```
5. В файл /etc/postgresql/16/main/pg_hba.conf добавляем разрешения для пользователя barman. После этого нужно делать рестард демона postgresql
6. В psql создадим тестовую базу otus: `CREATE DATABASE otus;`
7. В базе создаём таблицу test в базе otus: 
```
\c otus; 
CREATE TABLE test (id int, name varchar(30));
INSERT INTO test (id, name) VALUES (1, 'alex');
```
#### На хосте barman: 

1. После генерации ключа, выводим содержимое файла ~/.ssh/id_rsa.pub: 
`cat ~/.ssh/id_rsa.pub `
Копируем содержимое файла на сервер postgres в файл /var/lib/postgresql/.ssh/authorized_keys

2. Находясь в пользователе barman создаём файл ~/.pgpass c подобным содержимым:

```
192.168.100.104:5432:*:barman:Otus2026!
```

В данном файле указываются реквизиты доступа для postgres. Через знак двоеточия пишутся следующие параметры: 
-ip-адрес
-порт postgres
-имя БД (* означает подключение к любой БД)
-имя пользователя
-пароль пользователя

Так же не забыть сделать права chmod 600 .pgpass

3. После этого можно проверять возможность подключения к серверу с БД `psql -h 192.168.100.104 -U barman -d postgres` и проверяем репликацию:

```
barman@nfs:/home/wrqs$ psql -h 192.168.100.104 -U barman -c "IDENTIFY_SYSTEM" replication=1
      systemid       | timeline |  xlogpos  | dbname
---------------------+----------+-----------+--------
 7592948649153580540 |        1 | 0/5000148 |
(1 row)
```
4. Добавляем конфигурацию /etc/barman.conf и /etc/barman.d/node1.conf
5. Проверка работы barman и запуск бекапа

```
root@nfs:/home/wrqs# barman check node1
Server node1:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (interval provided: 4 days, latest backup age: 1 minute, 23 seconds)
        backup minimum size: OK (36.8 MiB)
        wal maximum age: OK (no last_wal_maximum_age provided)
        wal size: OK (16.2 KiB)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 1 backups, expected at least 1)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archiver errors: OK
root@nfs:/home/wrqs# barman backup --wait node1
Starting backup using postgres method for server node1 in /var/lib/barman/node1/base/20260108T161125
Backup start at LSN: 0/8000060 (000000010000000000000008, 00000060)
Starting backup copy via pg_basebackup for 20260108T161125
WARNING: pg_basebackup does not copy the PostgreSQL configuration files that reside outside PGDATA. Please manually backup the following files:
        /etc/postgresql/16/main/postgresql.conf
        /etc/postgresql/16/main/pg_hba.conf
        /etc/postgresql/16/main/pg_ident.conf

Copy done (time: 4 seconds)
Finalising the backup.
Backup size: 36.8 MiB
Backup end at LSN: 0/A000060 (00000001000000000000000A, 00000060)
Backup completed (start time: 2026-01-08 16:11:25.828077, elapsed time: 5 seconds)
Waiting for the WAL file 00000001000000000000000A from server 'node1'
Processing xlog segments from streaming for node1
        000000010000000000000008
        000000010000000000000009
        00000001000000000000000A
```
