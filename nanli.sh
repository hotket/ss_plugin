#!/bin/bash
rm -rf $0
echo
echo "#############################################################"
echo "# 作者：喃哩 https://www.xmfanguo.com                                 #"
echo "# 再次更新说明：增加判断是否开启Speedtest测试，防止跑流量    #"
echo "# 更新说明：取消了nohup后台，更换为更加稳定的supervisor      #"
echo "#############################################################"
echo

	echo "请等待自动操作..."
	#判断操作系统
		if [[ -f /etc/redhat-release ]]; then
			release="centos"
		elif cat /etc/issue | grep -q -E -i "debian"; then
			release="debian"
		elif cat /etc/issue | grep -q -E -i "ubuntu"; then
			release="ubuntu"
		elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
			release="centos"
		elif cat /proc/version | grep -q -E -i "debian"; then
			release="debian"
		elif cat /proc/version | grep -q -E -i "ubuntu"; then
			release="ubuntu"
		elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
			release="centos"
	  fi
	sleep 3
	clear
		echo "正在安装libsodium..."

if [[ ${release} = "centos" ]]; then
	yum -y install epel-release
	yum update -y nss curl libcurl  net-tools 
	yum install  libsodium  -y
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
	if [ -s /usr/bin/python3 ]; then
		Version=`/usr/bin/python3 -c 'import platform; print(platform.linux_distribution()[1][0])'`
	elif [ -s /usr/bin/python2 ]; then
		Version=`/usr/bin/python2 -c 'import platform; print platform.linux_distribution()[1][0]'`
	fi
	rm -rf *.rpm
	yum install python-pip git -y
	yum install iptables git -y
	yum -y install python-pip
yum install python-setuptools && easy_install pip
pip install setuptools==33.1.1
	yum -y install git gcc python-setuptools lsof lrzsz python-devel libffi-devel openssl-devel iptables
	yum -y groupinstall "Development Tools" 
    easy_install supervisor
	pip install --upgrade pip
	wget https://pypi.python.org/packages/source/p/pip/pip-1.3.1.tar.gz --no-check-certificate
chmod +x pip-1.3.1.tar.gz
tar xzvf pip-1.3.1.tar.gz
cd pip-1.3.1
python setup.py install
else
	apt-get update -y
	apt-get install libsodium-dev net-tools  -y
	apt-get install supervisor  python-pip lsof -y
	apt-get install build-essential wget -y
	apt-get install iptables git -y
	apt-get install python-pip git -y
	pip install cymysql
	fi
	#Check Root
	[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
	#check OS version
	cd /home
	git clone  https://github.com/llx1233/shadowsocks.git "/home/shadowsocksr"
	cd /home/shadowsocksr
	pip install -r requirements.txt
	chmod +x *.sh
	# 配置程序
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
	# 取消文件数量限制
	sed -i '$a * hard nofile 512000\n* soft nofile 512000' /etc/security/limits.conf
	read -p "请输入前端地址:(类似于:http://ss.tk) " Userdomain
	read -p "请输入muKey，如果未更改，回车默认mupass: " Usermukey
	read -p "请输入前端添加的节点ID: " UserNODE_ID
	install_ssr_for_each
	cd /home/shadowsocksr
	echo -e "modify Config.py...\n"
	sed -i "s#'zhaoj.in'#'jd.hk'#" /home/shadowsocksr/userapiconfig.py
	Userdomain=${Userdomain:-"http://ssr.tn"}
	sed -i "s#https://zhaoj.in#${Userdomain}#" /home/shadowsocksr/userapiconfig.py
	Usermukey=${Usermukey:-"mupass"}
	sed -i "s#glzjin#${Usermukey}#" /home/shadowsocksr/userapiconfig.py
    sed -i "6s#6#0#" /home/shadowsocksr/userapiconfig.py
	UserNODE_ID=${UserNODE_ID:-"3"}
	sed -i '2d' /home/shadowsocksr/userapiconfig.py
	sed -i "2a\NODE_ID = ${UserNODE_ID}" /home/shadowsocksr/userapiconfig.py
	# 启用supervisord
	supervisorctl shutdown
	#某些机器没有echo_supervisord_conf 
	wget -N -P  /etc/ --no-check-certificate  https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/supervisord.conf
	sed -i "s/\/root\/shadowsocks\/server.py/\/home\/shadowsocksr\/server.py/g" /etc/supervisord.conf
	supervisord
	#iptables
	iptables -F
	iptables -X  
iptables -I INPUT -p tcp -m tcp --dport 22:65535 -j ACCEPT
iptables -I INPUT -p udp -m udp --dport 22:65535 -j ACCEPT
iptables-save
service iptables save
service iptables restart
chmod +x /etc/rc.local
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /etc/rc.local
    chmod +x /etc/rc.local 
	echo "############################################################################"
	echo "# 安装完成，脚本已经加入开机自启动，请输入netstst -ntlp查看节点状态        #"
	echo "############################################################################"
