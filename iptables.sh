#! /bin/bash
sudo sysctl -p
sudo iptables -I FORWARD -i tun0 -o eth0 -j ACCEPT
sudo iptables -I FORWARD -i eth0 -o tun0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
