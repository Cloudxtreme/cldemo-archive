#!/bin/bash
export OS_USERNAME=admin
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://192.168.0.201:35357/v2.0
export OS_REGION_NAME=regionOne
export OS_PASSWORD=adminpw

for i in `seq 5 100`; do /usr/bin/nova network-create vmnet$i --fixed-range-v4 10.10.$i.0/24 --vlan $((200+i)); done
