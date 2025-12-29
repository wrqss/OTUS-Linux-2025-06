### DNS/BIND

Необходимо:
1. Взять стенд https://github.com/erlong15/vagrant-bind 
 - Добавить еще один сервер client2
 - Завести в зоне dns.lab имена:
 - web1 - смотрит на клиент1
 - web2  смотрит на клиент2
 - Завести еще одну зону newdns.lab
 - Завести в ней запись
 - www - смотрит на обоих клиентов

2. Настроить split-dns
 - client1 видит обе зоны, но в зоне dns.lab только web1
 - client2 видит только dns.lab


Результатом выполнения получился модифицированный Vagrantfile, переписанный под libvirt, с добавленной ВМ client2
Дополненные конфигурационные файлы и дополненный playbook.yml

Для проверки работы split-dns можно использовать утилиту ping:

Проверка на client:

```
wrqs@wrqs:~/bind/provisioning$ vagrant ssh client -c 'ping www.newdns.lab'
PING www.newdns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.013 ms
64 bytes from client (192.168.50.15): icmp_seq=2 ttl=64 time=0.027 ms
64 bytes from client (192.168.50.15): icmp_seq=3 ttl=64 time=0.027 ms
64 bytes from client (192.168.50.15): icmp_seq=4 ttl=64 time=0.026 ms
64 bytes from client (192.168.50.15): icmp_seq=5 ttl=64 time=0.026 ms
64 bytes from client (192.168.50.15): icmp_seq=6 ttl=64 time=0.027 ms
^C
--- www.newdns.lab ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5001ms
rtt min/avg/max/mdev = 0.013/0.024/0.027/0.006 ms
wrqs@wrqs:~/bind/provisioning$ vagrant ssh client -c 'ping web1.dns.lab'
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.011 ms
64 bytes from client (192.168.50.15): icmp_seq=2 ttl=64 time=0.027 ms
64 bytes from client (192.168.50.15): icmp_seq=3 ttl=64 time=0.028 ms
64 bytes from client (192.168.50.15): icmp_seq=4 ttl=64 time=0.027 ms
64 bytes from client (192.168.50.15): icmp_seq=5 ttl=64 time=0.028 ms
^C
--- web1.dns.lab ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4001ms
rtt min/avg/max/mdev = 0.011/0.024/0.028/0.007 ms
wrqs@wrqs:~/bind/provisioning$ vagrant ssh client -c 'ping web2.dns.lab'
ping: web2.dns.lab: Name or service not known
```
На хосте мы видим, что client видит обе зоны (dns.lab и newdns.lab), однако информацию о хосте web2.dns.lab он получить не может. 

Проверка на client2: 

```
wrqs@wrqs:~/bind/provisioning$ vagrant ssh client2 -c 'ping www.newdns.lab'
ping: www.newdns.lab: Name or service not known
wrqs@wrqs:~/bind/provisioning$ vagrant ssh client2 -c 'ping web1.dns.lab'
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=1 ttl=64 time=0.657 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=2 ttl=64 time=0.499 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=3 ttl=64 time=0.481 ms
^C
--- web1.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.481/0.545/0.657/0.083 ms
wrqs@wrqs:~/bind/provisioning$ vagrant ssh client2 -c 'ping web2.dns.lab'
PING web2.dns.lab (192.168.50.16) 56(84) bytes of data.
64 bytes from client2 (192.168.50.16): icmp_seq=1 ttl=64 time=0.022 ms
64 bytes from client2 (192.168.50.16): icmp_seq=2 ttl=64 time=0.037 ms
^C
--- web2.dns.lab ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.022/0.029/0.037/0.009 ms

```
Наглядно предсталено, что client2 видит всю зону dns.lab и не видит зону newdns.lab
