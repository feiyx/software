#!/bin/bash
#@author：feiyuanxing 【既然笨到家，就要努力到家】
#@date：2017-01-05
#@E-Mail：feiyuanxing@gmail.com
#@TARGET:一键安装hadoop 2.7.1 centos 64位 
#@CopyRight:本脚本遵守 未来星开源协议（http://feiyuanxing.com/kaiyuanxieyi/kaiyuanxieyi.html）

#讲解：
#1.请使用root用户执行，软件默认安装在work用户，通常会在linux的/home 挂载一个大型磁盘
#2.软件安装在/home/work/local/hadoop/hadoop  有人问为什么这么深
#   2.1 work目录下local包含所有软件 hadoop安装大数据生态圈其他软件
#   2.2 hadoop的数据安装在 /home/work/data ，此目录由于数量较大，可以单独挂载一个磁盘

INSTALL_HOME=/home/work/local/hadoop
ROOT_HOME=/home/work/local/hadoop/hadoop

#hadoop 数据路径
hadoop_logs=/home/work/data/hadoop/logs
hadoop_tmp=/home/work/data/hadoop/tmp

mkdir -p ${INSTALL_HOME}  &&  cd ${INSTALL_HOME}
mkdir -p ${hadoop_logs} && mkdir -p ${hadoop_tmp} && chown -R work:work /home/work/data/hadoop

function add_work_user(){
	adduer work -d /home/work
	passwd work

}

function install_jdk(){
# 有jdk
echo $JAVA_HOME



}


#下载hadoop
function download_hodoop(){
	wget http://public.feiyuanxing.com/hadoop/hadoop-2.7.1_x64.tar.gz
}

function configuration_ssh(){
	#设置本机免密码登录
	(echo -e "\n"
	sleep 1
	echo -e "\n"
	sleep 1
	echo -e "\n")|ssh-keygen -t rsa
	cat  ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	chmod 700  ~/.ssh
	chmod 600  ~/.ssh/authorized_keys

}

function configure_hadoop(){
	#最终生成的文件名为install_hadoop.bin而我们的all.tar.gz被>>到该文件后面
	#tail -c $size  install_hadoop.bin >all.tar.gz
	rm -rf hadoop
	tar -zxf hadoop-2.7.1_x64.tar.gz
	pwd
	mv hadoop-2.7.1 hadoop && cd hadoop

	echo "正在安装.请稍等..."

	#设置环境变量
	hadoop_home_test=`echo "${HADOOP_HOME}"`
	
	if [ -z  ${hadoop_home_test} ] ;then
		echo export HADOOP_HOME=${ROOT_HOME}/hadoop >> /etc/profile
		echo export PATH=$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin >> /etc/profile
		#使得环境变量生效
		source /etc/profile
		echo "hadoop 环境变量已存在..."
	fi
	
	#通过强大的sed命令来修改hadoop的配置文件
	jdk_home=`echo $JAVA_HOME`
	if [ -z ${jdk_home} ] ;then
		#安装JDK
		echo "安装JDK"
	fi
		
	sed -i "s!\${JAVA_HOME}!$(echo ${jdk_home})!g" ${ROOT_HOME}/etc/hadoop/hadoop-env.sh
	sed -i "/<configuration>/a\<property\>\n\<name\>fs.default.name\<\/name\>\n\<value\>hdfs://localhost:9000\<\/value\>\n\<\/property\>\n\<property\>\n\<name\>hadoop.tmp.dir\<\/name\>\n\<value\>$(echo ${hadoop_tmp})\<\/value\>\n\</property\>"  ${ROOT_HOME}/etc/hadoop/core-site.xml
	cp ${ROOT_HOME}/etc/hadoop/mapred-site.xml.template  ${ROOT_HOME}/etc/hadoop/mapred-site.xml
	sed -i '/<configuration>/a\<property\>\n\<name\>mapred.job.tracker\</name\>\n\<value\>localhost:9001\</value\>\n\</property\>'  ${ROOT_HOME}/etc/hadoop/mapred-site.xml
	sed -i '/<configuration>/a\\<property\>\n\<name\>dfs.replication\</name\>\n\<value\>1\</value\>\n\</property\>'   ${ROOT_HOME}/etc/hadoop/hdfs-site.xml
	
	chown -R work:work ${INSTALL_HOME}
	echo "hadoop安装完成,开始格式化。。。"

}

function start_hadoop(){
	#格式化hadoop
	hadoop namenode -format
	echo "格式化完成..开始运行"
	#启动
	start-all.sh

}
#add_work_user
download_hodoop;
#configuration_ssh
configure_hadoop;



exit




