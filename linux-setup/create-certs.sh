#!/bin/bash

sudo mkdir -p /etc/ssl/selfsigned
cd /etc/ssl/selfsigned

touch index.txt
echo 01 > serial

sudo rm -r keys
sudo rm -r certs

sudo mkdir keys
sudo mkdir certs


public_ip=$(curl -s ifconfig.me)

sudo openssl req -x509 -nodes -newkey rsa:2048 \
-keyout keys/ca.key -out certs/ca.crt -subj "/C=MX/O=DreamTeam"

sudo openssl req -nodes -newkey rsa:2048 \
-keyout keys/server.key -out certs/server.csr -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl req -nodes -newkey rsa:2048 \
-keyout keys/client.key -out certs/client.csr -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl x509 -req -in certs/server.csr \
-CA certs/ca.crt -CAkey keys/ca.key -set_serial 01 -out certs/server.crt

sudo openssl x509 -req -in certs/client.csr \
-CA certs/ca.crt -CAkey keys/ca.key -set_serial 02 -out certs/client.crt

sudo chmod 777 keys/client.key
sudo chmod 777 certs/client.crt
sudo chmod 777 certs/client.crt
