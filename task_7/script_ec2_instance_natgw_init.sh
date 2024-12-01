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
sudo iptables -F
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o ens5 -s 10.0.3.0/24 -j MASQUERADE
sudo iptables -F FORWARD
sudo service iptables save

sudo yum install nginx -y
sudo systemctl start nginx.service

echo 'server {
  listen 80;
  server_name localhost 127.0.0.1;

  location / {
    proxy_pass         http://10.0.3.10:32000;
    proxy_redirect     off;
    proxy_set_header   Host $host;
    proxy_set_header   X-Real-IP $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Host $server_name;
  }

  listen 9090;
  server_name localhost 127.0.0.1;

  location / {
    proxy_pass         http://10.0.3.10:32090;
    proxy_redirect     off;
    proxy_set_header   Host $host;
    proxy_set_header   X-Real-IP $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Host $server_name;
  }
}' >> /etc/nginx/conf.d/proxy.conf

sudo service nginx restart