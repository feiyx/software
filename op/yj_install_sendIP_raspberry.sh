#!/bin/bash
#@author：feiyuanxing 【既然笨到家，就要努力到家】
#@date：2017-12-20
#@E-Mail：feiyuanxing@gmail.com
#@TARGET: auto send ip by shell
#@CopyRight:本脚本开源Github地址（https://github.com/feiyx）

#切换到root用户
WHOAMI=`whoami`
if [ ! ${WHOAMI} = "root" ] ; then
	echo "请输入本机root用户密码，如果忘记请在pi用户下执行（sudo passwd root）："
	su root
fi

read -p "请输入发件人邮箱，建议回车默认使用官方邮箱：" yourMail
read -p "请输入你的邮箱密码，建议回车默认使用官方邮箱，切记126邮箱是授权码，获得途径请查看：https://jingyan.baidu.com/article/9faa72318b76bf473c28cbf7.html
" yourMailPasswd
read -p "请输入你邮箱smtp协议网址，建议回车默认使用官方邮箱：126邮箱:smtp.126.com ；QQ邮箱 smtp.qq.com
" yourMailSMTP

if [ x"" = x"${yourMail}" ] ; then
	yourMail=weilx_info@126.com
fi
if [ x"" = x"${yourMailSMTP}" ] ; then
	yourMailSMTP=smtp.126.com
fi
if [ x"" = x"${yourMailPasswd}" ] ; then
	yourMailPasswd=weilxPASSWD783
fi


mkdir -p ~/script && cd ~/script/
ROOT_HOME=$(cd `dirname $0`; pwd)

install_soft(){
	echo "开始安装基础环境(msmtp and mutt ...)"
	sudo apt install msmtp
	sudo apt-get update 
	sudo apt install mutt

}

configure_env(){
#环境
echo "account default
host ${yourMailSMTP}
from ${yourMail}
auth plain
user ${yourMail}
password ${yourMailPasswd}
# 生产环境不记录日志
# logfile /var/log/msmtp.log

" > ~/.msmtprc

echo "set sendmail="/usr/bin/msmtp"
set use_from=yes
set realname="RaspberryPi"
set editor="vim"

" > ~/.muttrc


chmod 0600 ~/.msmtprc


sudo echo '#!/bin/bash

### BEGIN INIT INFO  
# Provides:          autoSendIp 
# Required-Start:    $remote_fs
# Required-Stop:     $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# author：feiyuanxing
# E-Mail：feiyuanxing@gmail.com
# date：2017-12-20
# TARGET: auto send ip by shell
# @CopyRight:本脚本开源Github地址（https://github.com/feiyx）
# Short-Description: Start or stop the /dev/video0 
### END INIT INFO

start(){
	su pi
	# check network availability
	while true
	do
	  TIMEOUT=5
	  SITE_TO_CHECK="www.baidu.com"
	  RET_CODE=`curl -I -s --connect-timeout $TIMEOUT $SITE_TO_CHECK -w %{http_code} | tail -n1`
	  if [ "x$RET_CODE" = "x200" ]; then
	  echo "Network OK, will send mail..."
	  break
	  else
	  echo "Network not ready, wait..."
	  sleep 1s
	  fi
	done

	#ETH0_IP_ADDR=`ifconfig eth0 | sed -n "2,2p" | awk "{print substr($2,1)}"`
	ETH0_IP_ADDR=`ifconfig `
	# send the Email
	echo "Current time: `date "+%F %T"`. Enjoy it ${ETH0_IP_ADDR}" | mutt -s "IP Address of Raspberry Mail" '${yourMail}'

}

stop(){
    echo -n "stop osprey"
}

case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
*)
    echo "Usage: $0 (start|stop)"
    ;;
esac


' >  /etc/init.d/autoSendIp
chmod +x /etc/init.d/autoSendIp
update-rc.d autoSendIp defaults

echo "安装成功，试试重启自动发送邮件到${yourMail}!"


}

#install_soft
configure_env

