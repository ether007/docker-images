FROM centos:7

MAINTAINER chenlong.xiao
##docker build -f java8.Dockerfile -t xcl/jdk8 .
##docker run -it --rm  xcl/jdk8 bash


RUN yum -y install  wget tar net-tools

RUN mkdir /opt/java &&\
	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/jdk-8u144-linux-x64.tar.gz -P /opt/java

RUN tar zxvf /opt/java/jdk-8u144-linux-x64.tar.gz -C /opt/java &&\
	rm -rf /opt/java/jdk-8u144-linux-x64.tar.gz

ENV JAVA_HOME /opt/java/jdk1.8.0_144
ENV PATH $PATH:$JAVA_HOME/bin 


