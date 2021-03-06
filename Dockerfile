FROM centos:7.7.1908
MAINTAINER zhangdd
LABEL Description="基于CentOS 7,安装了jre 8和tomcat8.5"  Version="1.0"
#root
RUN echo "root:123456" | chpasswd
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo 'Asia/Shanghai' >/etc/timezone
ENV CATALINA_HOME /webapp/tomcat8
ENV CATALINA_BASE $CATALINA_HOME
ENV PATH $PATH:$CATALINA_HOME/bin
ENV JAVA_HOME /usr/local/jdk1.8.0
ENV PATH $PATH:/$JAVA_HOME/bin
#jdk
ADD jdk1.8.0 /usr/local/jdk1.8.0
# 创建tomcat的用户,并自动创建用户目录, 指定tomcat用户使用bash
RUN groupadd -g 1001 tomcat
RUN useradd -d /webapp -u 1001 -g tomcat --shell /bin/bash tomcat
# 设置tomcat用户的密码
RUN echo "tomcat:123456" | chpasswd
# 将tomcat的压缩包放到 /webapp/tomcat8/ 目录下
ADD tomcat8  /webapp/tomcat8
# 将工作目录切换到 /webapp/tomcat8/, 之后的操作, 的基础目录为 /webapp/tomcat8/
WORKDIR /webapp/
# 修改 /webapp/tomcat8/ 目录的拥有者为tomcat. (默认的拥有者为root)
RUN chown -R tomcat:tomcat  /webapp/
#chmod +x 
RUN chmod +x /webapp/tomcat8/bin/*
RUN chmod 766 /webapp/tomcat8/logs
# 将当前操作者的身份从root切换为tomcat, 后续所有操作, 都将是以tomcat身份运行
USER tomcat
# 容器监听 8080端口
EXPOSE 8080
# 容器启动后, 自动执行 tomcat的catalina.sh脚本, 以run模式运行tomcat. 这里注意:容器中的服务必须以前台方式运行.
CMD [ "/webapp/tomcat8/bin/catalina.sh","run" ]
