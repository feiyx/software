#!/bin/bash
#@author：feiyuanxing 【既然笨到家，就要努力到家】
#@date：2017-12-05
#@E-Mail：feiyuanxing@gmail.com
#@TARGET:一键安装JDK 
#@CopyRight:本脚本遵守 未来星开源协议（http://feiyuanxing.com/kaiyuanxieyi/kaiyuanxieyi.html）

#未来星的规则是所有的软件均在/home 下
#jdk 安装在/home/root/jdk/jdk1.8
ROOT_HOME=/home/root/jdk

mkdir -p ${ROOT_HOME} && cd ${ROOT_HOME}

IS_ALLOW_DAN=""

#1.安装1.6，请输入6
#2.安装1.7，请输入7
#3.安装1.8，请输入8
read -t 20 -p "#1.安装1.6，请输入6
#2.安装1.7，请输入7
#3.安装1.8，请输入8 " answer
echo "answer:" ${answer}

java_home_before=`cat /etc/profile| grep "JAVA_HOME"`
if [ -n "$java_home_before" ] ; then
	read -t 30 -p "#环境变量中含有JAVA_HOME,是否覆盖安装,默认No yes/no?" cover
	echo "cover:" ${cover}
	if [ "${cover}"="yes" ] ; then
		sed -i '/JAVA_HOME/d' /etc/profile
		echo "正在覆盖安装...";
	else
		echo "不覆盖安装，已退出";
		exit;
	fi
fi

if [ "${answer}" = "6" ] ; then
	IS_ALLOW_DAN="6";
	
elif [ "${answer}" = "7" ] ;then
	IS_ALLOW_DAN="7";
	if [ ! -f ${ROOT_HOME}/jdk-7u80-linux-x64.tar.gz ] ; then
		wget http://pan.feiyuanxing.com/jdk/linux/linux1.7/jdk-7u80-linux-x64.tar.gz --http-user=feiyuanxing --http-passwd=feiyuanxing
	fi
	
	tar -zxf jdk-7u80-linux-x64.tar.gz
	mv jdk1.7.0_80 jdk1.7
	cd jdk1.7
	
	echo export JAVA_HOME=${ROOT_HOME}/jdk1.7 >> /etc/profile
	echo 'export PATH=$PATH:${JAVA_HOME}/bin' >> /etc/profile
	#使得环境变量生效
	sleep 1
	source /etc/profile
	sleep 1
	source /etc/profile
		

	IS_ALLOW_DAN="7";
elif [ "${answer}" = "8" ] ;then
	IS_ALLOW_DAN="8";
	if [ ! -f ${ROOT_HOME}/jdk-8u77-linux-x64.gz ] ; then
		wget http://pan.feiyuanxing.com/jdk/linux/linux1.8/jdk-8u77-linux-x64.gz --http-user=feiyuanxing --http-passwd=feiyuanxing
	fi
	
	tar -zxf jdk-8u77-linux-x64.gz
	mv jdk1.8.0_77 jdk1.8
	cd jdk1.8
	echo export JAVA_HOME=${ROOT_HOME}/jdk1.8 >> /etc/profile
	echo 'export PATH=$PATH:${JAVA_HOME}/bin' >> /etc/profile
	#使得环境变量生效
	sleep 1
	source /etc/profile
	sleep 1
	source /etc/profile
fi

chown -R root:root ${ROOT_HOME}

echo "IS_ALLOW_DAN :" $IS_ALLOW_DAN


