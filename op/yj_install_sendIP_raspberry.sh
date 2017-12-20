#!/bin/bash
#@author：feiyuanxing 【既然笨到家，就要努力到家】
#@date：2017-12-20
#@E-Mail：feiyuanxing@gmail.com
#@TARGET: auto send ip by shell
#@CopyRight:本脚本开源Github地址（https://github.com/feiyx）


read -p "请输入你的126邮箱：" yourMail
read -p "请输入你的126邮箱密码，切记此处是授权码，获得途径请查看：https://jingyan.baidu.com/article/9faa72318b76bf473c28cbf7.html
" yourMailPasswd
read -p "请输入你邮箱smtp协议网址：126邮箱:smtp.aliyun.com ；QQ邮箱 smtp.qq.com
" yourMailSMTP


mkdir -p ~/script && cd ~/script/
ROOT_HOME=$(cd `dirname $0`; pwd)

install_soft(){
	echo "开始安装msmtp and mutt ..."
	sudo apt install msmtp
	sudo apt install mutt

}

configure_env(){
#环境
echo "
account default
host ${yourMailSMTP}
from ${yourMail}
auth plain
user ${yourMail}
password ${yourMailPasswd}
logfile /var/log/msmtp.log

" > .msmtprc

echo "
set sendmail="/usr/bin/msmtp"
set use_from=yes
set realname="RaspberryPi"
set editor="vim"

" > .muttrc


sudo echo '#!/bin/bash
#@author：feiyuanxing
#@date：2017-12-20
#@E-Mail：feiyuanxing@gmail.com
#@TARGET: auto send ip by shell
#@CopyRight:本脚本开源Github地址（https://github.com/feiyx）

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

' > auto_send_ip.sh
sudo sed -i '/auto_send_ip/d' /etc/rc.local
#sudo echo "${ROOT_HOME}/auto_send_ip.sh" >> /etc/rc.local
#sudo sh -c ''${ROOT_HOME}'/auto_send_ip.sh >> /etc/rc.local' 
sudo sh -c 'echo "/bin/sh '${ROOT_HOME}'/auto_send_ip.sh" >> /etc/rc.local' 

echo "安装成功，试试重启自动发送邮件到${yourMail}!"


}

install_soft
configure_env

