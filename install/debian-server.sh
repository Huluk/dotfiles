#!/usr/bin/env sh
set -e

# Routing
sudo apt install nginx
sudo apt install certbot python3-certbot-nginx

# Security
sudo apt install fail2ban iptables
sudo apt install ufw

# Dart
sudo apt install lsb-release dirmngr software-properties-common apt-transport-https ca-certificates

wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |
  sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg

sudo apt update
sudo apt install dart
dart --disable-analytics

# TaskHeap specific
sudo apt install postgresql
sudo apt install protobuf-compiler
sudo apt install libssl-dev libssl-doc
zef install cro
dart pub global activate protoc_plugin
