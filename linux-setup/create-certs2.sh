#!/bin/bash

sudo rm -r /etc/ssl/selfsigned
sudo mkdir /etc/ssl/selfsigned
cd /etc/ssl/selfsigned

public_ip=$(curl -s ifconfig.me)

sudo openssl req -x509 -nodes -newkey rsa:2048 \
-keyout ca.pem -out ca.crt -subj "/C=MX/O=DreamTeam"

sudo openssl req -nodes -newkey rsa:2048 \
-keyout server.pem -out server.csr -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl req -nodes -newkey rsa:2048 \
-keyout client.pem -out client.csr -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl x509 -req -in server.csr \
-CA ca.crt -CAkey ca.pem -set_serial 01 -out server.crt

sudo openssl x509 -req5 -in client.csr \
-CA ca.crt -CAkey ca.pem -set_serial 02 -out client.crt

sudo chmod 777 client.pem
sudo chmod 777 client.crt
sudo chmod 777 client.crt
