#!/bin/bash

useradd otusadm && useradd otus
echo "otusadm:Otus2025!" | chpasswd && echo "otus:Otus2025!" | chpasswd
groupadd -f admin
usermod otusadm -a -G admin && usermod root -a -G admin
