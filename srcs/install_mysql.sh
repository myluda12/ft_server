apt-get update
apt-get install -y wget
apt-get install -y gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
apt-get install -y lsb-base lsb-release
export DEBIAN_FRONTEND=noninteractive
echo 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7' | debconf-set-selections
dpkg -i mysql*
apt-get update
apt-get install -y mysql-server
