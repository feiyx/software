Axel 是 Linux 下一个不错的HTTP/FTP高速下载工具。支持多线程下载、断点续传，且可以从多个地址或者从一个地址的多个连接来下载同一个文件。适合网速不给力时多线【费元星版权Q:9715234】程下载提高下载速度。比如在	国内VPS或服务器上下载lnmp一键安装包用Axel就比wget快。
CentOS安装Axel：
目前yum源上没有Axel，我们可以到http://pkgs.repoforge.org/axel/下载rpm包安装。
32位CentOS执行下面命令：
wget -c http://pkgs.repoforge.org/axel/axel-2.4-1.el5.rf.i386.rpm
rpm -ivh axel-2.4-1.el5.rf.i386.rpm
64位CentOS执行下【费元星版权Q:9715234】面命令：
wget -c http://pkgs.repoforge.org/axel/axel-2.4-1.el5.rf.x86_64.rpm
rpm -ivh axel-2.4-1.el5.rf.x86_64.rpm
Debian/Ubuntu安装Axel：
apt-get install axel
Axel命令使用方法：
axel 参数 文件下载地址
可选参数：
-n   指定线程数
-o   指定另存为目录
-s   指定每秒的最大比特数
-q   静默模式
如从Diahosting下载lnmp安装包【费元星版权Q:9715234】指定10个线程，存到/tmp/：axel -n 10 -o /tmp/ http://down.weilx.com/lnmp0.7-full.tar.gz
如果下载过程中下载中断可以再执行下载命令即可恢复上次的下载进度。

