#!/bin/bash
sudo yum install iptables -y
sudo yum install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables

# Turning on IP Forwarding
sudo touch /etc/sysctl.d/custom-ip-forwarding.conf
sudo chmod 666 /etc/sysctl.d/custom-ip-forwarding.conf
sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/custom-ip-forwarding.conf
sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

# Making a catchall rule for routing and masking the private IP
sudo iptables -t nat -A POSTROUTING -o ens5 -s 10.0.3.0/24 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o ens5 -s 10.0.4.0/24 -j MASQUERADE
sudo iptables -F FORWARD
sudo service iptables save