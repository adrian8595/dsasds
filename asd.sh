#!/bin/bash

# 更新系统并安装danted
sudo apt-get update
sudo apt-get install -y dante-server

# 配置danted
cat <<EOL | sudo tee /etc/danted.conf
logoutput: syslog /var/log/danted.log
internal: 0.0.0.0 port=5794
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

# 创建用户并设置密码
sudo useradd -m knbc3asas1a
echo "knbc3asas1a:74bds3jada" | sudo chpasswd

# 设置系统权限

sudo usermod -a -G shadow nobody
sudo chown root:shadow /etc/shadow
sudo chmod 640 /etc/shadow

# 重启danted服务
sudo systemctl restart danted



echo "SOCKS5 proxy server is set up on port 5794 with user 'knbc3asas1a'."
