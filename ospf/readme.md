#### OSPF
Необходимо создать 3 ВМ

- Объединить их разными vlan

- Поднять OSPF между машинами
- Изобразить ассиметричный роутинг
- Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным


<img width="381" height="320" alt="image" src="https://github.com/user-attachments/assets/490cc401-fee2-4265-8210-04623bbfa060" />

Результатом получается:
```
vagrant ssh router1 -c 'ip -br a'
lo               UNKNOWN        127.0.0.1/8
eth0             UP             192.168.121.32/24 metric 100 fe80::5054:ff:fe8c:ae65/64
r1r2             UP             10.0.10.1/30 fe80::5054:ff:fe10:101/64
r1r3             UP             10.0.12.1/30 fe80::5054:ff:fe10:201/64
lan1             UP             192.168.10.1/24 fe80::5054:ff:fe20:101/64
```
```
vagrant ssh router2 -c 'ip -br a'
lo               UNKNOWN        127.0.0.1/8
eth0             UP             192.168.121.206/24 metric 100 fe80::5054:ff:fe0b:f513/64
r1r2             UP             10.0.10.2/30 fe80::5054:ff:fe10:102/64
r2r3             UP             10.0.11.2/30 fe80::5054:ff:fe10:302/64
lan2             UP             192.168.20.1/24 fe80::5054:ff:fe20:202/64
```

``` 
vagrant ssh router3 -c 'ip -br a'
lo               UNKNOWN        127.0.0.1/8
eth0             UP             192.168.121.163/24 metric 100 fe80::5054:ff:fee6:342c/64
r2r3             UP             10.0.11.1/30 fe80::5054:ff:fe10:303/64
r1r3             UP             10.0.12.2/30 fe80::5054:ff:fe10:203/64
lan3             UP             192.168.30.1/24 fe80::5054:ff:fe20:303/64
```

Текущие Cost:
```
 vagrant ssh router1 -c 'sudo vtysh -c "show ip ospf interface r1r2"'
r1r2 is up
  ifindex 3, MTU 1500 bytes, BW 0 Mbit <UP,LOWER_UP,BROADCAST,RUNNING,MULTICAST>
  Internet Address 10.0.10.1/30, Broadcast 10.0.10.3, Area 0.0.0.0
  MTU mismatch detection: disabled
  Router ID 1.1.1.1, Network Type BROADCAST, Cost: 1000
  Transmit Delay is 1 sec, State Backup, Priority 1
  Designated Router (ID) 2.2.2.2 Interface Address 10.0.10.2/30
  Backup Designated Router (ID) 1.1.1.1, Interface Address 10.0.10.1
  Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
  Timer intervals configured, Hello 10s, Dead 30s, Wait 30s, Retransmit 5
    Hello due in 9.343s
  Neighbor Count is 1, Adjacent neighbor count is 1
  Graceful Restart hello delay: 10s
  LSA retransmissions: 1
``` 
```  
vagrant ssh router2 -c 'sudo vtysh -c "show ip ospf interface r1r2"'
r1r2 is up
  ifindex 3, MTU 1500 bytes, BW 0 Mbit <UP,LOWER_UP,BROADCAST,RUNNING,MULTICAST>
  Internet Address 10.0.10.2/30, Broadcast 10.0.10.3, Area 0.0.0.0
  MTU mismatch detection: disabled
  Router ID 2.2.2.2, Network Type BROADCAST, Cost: 100
  Transmit Delay is 1 sec, State DR, Priority 1
  Designated Router (ID) 2.2.2.2 Interface Address 10.0.10.2/30
  Backup Designated Router (ID) 1.1.1.1, Interface Address 10.0.10.1
  Saved Network-LSA sequence number 0x80000004
  Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
  Timer intervals configured, Hello 10s, Dead 30s, Wait 30s, Retransmit 5
    Hello due in 3.371s
  Neighbor Count is 1, Adjacent neighbor count is 1
  Graceful Restart hello delay: 10s
  LSA retransmissions: 0
```

Линк r1r2 сделан “дорогим”  поэтому OSPF его не выбирает при наличии более дешёвого пути.

Так как он остаётся в топологии, значит при падении пути через R3 OSPF переключится на r1r2 (пусть и дорогой), и связность сохранится.

```
vagrant ssh router3 -c 'sudo ip link set r2r3 down'
vagrant ssh router2 -c 'sudo vtysh -c "show ip route 192.168.10.0/24"'
```

В случае отключения должен стать 10.0.10.1 через r1r2.
```
 vagrant ssh router2 -c 'sudo vtysh -c "show ip route 192.168.10.0/24"'
Routing entry for 192.168.10.0/24
  Known via "ospf", distance 110, metric 110, best
  Last update 00:00:10 ago
  Flags: Selected
  Status: Installed
  * 10.0.10.1, via r1r2, weight 1
```
Теперь возвращаем

`vagrant ssh router3 -c 'sudo ip link set r2r3 up'`
И проверяем

```
vagrant ssh router2 -c 'sudo vtysh -c "show ip route 192.168.10.0/24"'
Routing entry for 192.168.10.0/24
  Known via "ospf", distance 110, metric 30, best
  Last update 00:00:15 ago
  Flags: Selected
  Status: Installed
  * 10.0.11.1, via r2r3, weight 1
```
