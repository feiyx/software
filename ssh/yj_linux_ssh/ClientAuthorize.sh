#!/bin/bash
#@author：feiyuanxing 【既然笨到家，就要努力到家】
#@date：2017-12-05
#@E-Mail：feiyuanxing@gmail.com
#@TARGET:一键安装做ssh免密登录
#@CopyRight:本脚本遵守 未来星开源协议（http://feiyuanxing.com/kaiyuanxieyi/kaiyuanxieyi.html）


ROOT_HOME=$(cd `dirname $0`; pwd)

if [ ! -f "${ROOT_HOME}"/hostip.out ];then
    echo "请在同目录下的 hostip.out 文件中添加您需要免密登录的机器"
	echo "#127.0.0.1
191.168.199.1" > hostip.out
	exit;
fi


#声明环境变量
export PATH="/usr/lib/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
export LANG="en_US.UTF-8"

IS_ALLOW_DAN=""
#1.只允许本机免密登录从机
#2.允许所有机器之间免密登录
echo -e "只允许本机免密登录从机请输入：1 
允许所有机器之间免密登录输入：2 。默认是1： 
\c"
read answer
echo "answer:" ${answer}
if [ "${answer}" = "2" ] ; then
	IS_ALLOW_DAN="2";
else 
	IS_ALLOW_DAN="1";
fi

#echo " $IS_ALLOW_DAN is the right response."


#生成管理机的公私钥
ssh-keygen -t rsa -P '' -f ~/.ssh/identity
#设置管理机的相关目录权限
chmod go-w /root
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
#将生成的公钥信息导入ServerAuthorize.sh脚本中
rsapub_var=$(cat /root/.ssh/identity.pub)
echo "${rsapub_var}" >> /root/.ssh/authorized_keys
chmod u+x /tmp/authorize/ServerAuthorize.sh

if [ $IS_ALLOW_DAN = "1" ] ; then
	#通过for循环将脚本分发到各个被管理机
	for host_ip in $(cat "${ROOT_HOME}"/hostip.out)
	do
		scp -o StrictHostKeyChecking=no -rp /root/.ssh/authorized_keys "${host_ip}":/root/.ssh/
	done
else
	#通过for循环将脚本分发到各个被管理机
	for host_ip in $(cat "${ROOT_HOME}"/hostip.out)
	do
			ssh "${host_ip}" "ssh-keygen -t rsa -P '' -f ~/.ssh/identity"
			scp -o StrictHostKeyChecking=no -rp "${host_ip}":~/.ssh/identity.pub ~/.ssh/identity.pub.tmp
			cat ~/.ssh/identity.pub.tmp >> ~/.ssh/authorized_keys
			rm -rf ~/.ssh/identity.pub.tmp
			
	done 


	for host_ip in $(cat "${ROOT_HOME}"/hostip.out)
	do
				scp -o StrictHostKeyChecking=no -rp /root/.ssh/authorized_keys "${host_ip}":/root/.ssh/
	done 

fi
