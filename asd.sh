#!/bin/bash

param1=$1
param2=$2
param3=$3

sudo apt-get update
echo "1. ubuntu系统更新完成"
sudo apt-get install -y dante-server
echo "2. dante安装完成"
cat <<EOL | sudo tee /etc/danted.conf
logoutput: syslog /var/log/danted.log
internal: 0.0.0.0 port=$param3
external: eth0
socksmethod: username

user.privileged: root
user.notprivileged: nobody
user.libwrap: nobody

client pass {
   from: 0.0.0.0/0 to: 0.0.0.0/0
   log: connect disconnect error
}

socks pass {
   from: 0.0.0.0/0 to: 0.0.0.0/0
   protocol: tcp udp
   socksmethod: username
   log: connect disconnect error
}
EOL

echo "3. dante配置完成"

sudo useradd -m $param1
echo "$param1:$param2" | sudo chpasswd

echo "4. 代理用户新建完成"

sudo usermod -a -G shadow nobody
sudo chown root:shadow /etc/shadow
sudo chmod 640 /etc/shadow

echo "5. 代理用户权限完成"

sudo systemctl restart danted

echo "6. SOCKS5代理配置成功"
