#!/usr/bin/env bash


apt update && apt upgrade -y
apt install -y firewalld
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --zone=public --add-port=2379/tcp --permanent
firewall-cmd --zone=public --add-port=2380/tcp --permanent
firewall-cmd --zone=public --add-port=6443/tcp --permanent

firewall-cmd --reload
