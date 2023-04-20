#!/bin/bash

mkdir /etc/ssl/selfsigned
cd /etc/ssl/selfsigned

public_ip=$(curl -s ifconfig.me)

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout ca.key -out ca.crt -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl req -nodes -days 365 -newkey rsa:2048 \
-keyout server.key -out server.csr -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl req -nodes -days 365 -newkey rsa:2048 \
-keyout client.key -out client.csr -subj "/C=MX/O=DreamTeam/CN=$public_ip"

sudo openssl x509 -req -days 365 -in server.csr \
-CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

sudo openssl x509 -req -days 365 -in client.csr \
-CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt
