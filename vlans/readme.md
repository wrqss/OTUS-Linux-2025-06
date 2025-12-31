### VLAN, LACP

В Office1 в тестовой подсети появляется сервера с доп интерфейсами и адресами.
В internal сети testLAN:

- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
 - testServer2- 10.10.10.1

Равести вланами:

testClient1 <-> testServer1

testClient2 <-> testServer2

Между centralRouter и inetRouter "пробросить" 2 линка (общая inernal сеть) и объединить их в бонд, проверить работу c отключением интерфейсов

<img width="1406" height="1376" alt="image" src="https://github.com/user-attachments/assets/afc76918-dafc-40bc-a5af-5bbc288728a3" />

Протокол VLAN разделяет хосты на подсети, путём добавления тэга к каждому кадру (Протокол 802.1Q). Группа устройств в сети VLAN взаимодействует так, будто устройства подключены с помощью одного кабеля.

Проверка VLAN:
```
vagrant ssh testServer1 -c 'ip -br a'
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             192.168.121.117/24 fe80::5054:ff:fe0b:f9aa/64
eth1             UP             fe80::aaf4:90f9:4090:4aad/64
eth2             UP             192.168.56.22/24 fe80::5054:ff:fe77:8683/64
eth1.1@eth1      UP             10.10.10.1/24 fe80::5054:ff:feee:c539/64

vagrant ssh testServer2 -c 'ip -br a'
lo               UNKNOWN        127.0.0.1/8
eth0             UP             192.168.121.72/24 metric 100 fe80::5054:ff:febb:d57/64
eth1             UP             fe80::5054:ff:fecc:68e1/64
eth2             UP             192.168.56.32/24 fe80::5054:ff:fe9a:1599/64
vlan2@eth1       UP             10.10.10.1/24 fe80::5054:ff:fecc:68e1/64
```

```
vagrant ssh testServer2 -c 'ping 10.10.10.254'
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.584 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.566 ms
^C
--- 10.10.10.254 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1009ms
rtt min/avg/max/mdev = 0.566/0.575/0.584/0.009 ms

vagrant ssh testServer1 -c 'ping 10.10.10.254'
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.464 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.509 ms
^C
--- 10.10.10.254 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1003ms
rtt min/avg/max/mdev = 0.464/0.486/0.509/0.031 ms
```

LACP (англ. link aggregation control protocol) — открытый стандартный протокол агрегирования каналов, описанный в документах IEEE 802.3ad и IEEE 802.1aq.

На ВМ centralRouter, inetRouter Bond интерфейс будет работать через порты eth1 и eth2.

Тестирование будет проводить путем отключения интерфейса на centralRouter

 `vagrant ssh centralRouter -c 'sudo ip link set down eth1'`
 `vagrant ssh centralRouter -c 'sudo ip link set up eth1'`

 ```vagrant ssh inetRouter -c "cat /proc/net/bonding/bond0; ping  192.168.255.2"
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: None
Currently Active Slave: eth1
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: eth1
MII Status: up
Speed: Unknown
Duplex: Unknown
Link Failure Count: 0
Permanent HW addr: 52:54:00:66:0f:41
Slave queue ID: 0

Slave Interface: eth2
MII Status: up
Speed: Unknown
Duplex: Unknown
Link Failure Count: 0
Permanent HW addr: 52:54:00:bf:a4:35
Slave queue ID: 0
PING 192.168.255.2 (192.168.255.2) 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=0.790 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=0.566 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=0.608 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=0.599 ms
64 bytes from 192.168.255.2: icmp_seq=5 ttl=64 time=0.501 ms
64 bytes from 192.168.255.2: icmp_seq=6 ttl=64 time=0.616 ms
64 bytes from 192.168.255.2: icmp_seq=7 ttl=64 time=0.544 ms
64 bytes from 192.168.255.2: icmp_seq=8 ttl=64 time=0.504 ms
64 bytes from 192.168.255.2: icmp_seq=9 ttl=64 time=0.538 ms
64 bytes from 192.168.255.2: icmp_seq=10 ttl=64 time=0.534 ms
64 bytes from 192.168.255.2: icmp_seq=11 ttl=64 time=0.612 ms
64 bytes from 192.168.255.2: icmp_seq=12 ttl=64 time=0.502 ms
64 bytes from 192.168.255.2: icmp_seq=13 ttl=64 time=0.551 ms
64 bytes from 192.168.255.2: icmp_seq=14 ttl=64 time=0.525 ms
64 bytes from 192.168.255.2: icmp_seq=15 ttl=64 time=0.484 ms
64 bytes from 192.168.255.2: icmp_seq=16 ttl=64 time=0.461 ms
```
Пинг во время отключения и включения интерфецса не прерывался 
