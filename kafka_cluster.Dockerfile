FROM centos:7

MAINTAINER xiaochenlong

## docker build -t xcl/kafka_cluster -f kafka_cluster.Dockerfile .

##docker run -itd --name zk zookeeper
## docker run -itd --name k1 --link zk:zookeeper --env BROKER_PORT=9091 --env BROKER_ID=1 -p9091:9092  xcl/kafka_cluster
## docker run -itd --name k2 --link zk:zookeeper --env BROKER_PORT=9092 --env BROKER_ID=2 -p9092:9092  xcl/kafka_cluster
## docker run -itd --name k3 --link zk:zookeeper --env BROKER_PORT=9093 --env BROKER_ID=3 -p9093:9092  xcl/kafka_cluster

ENV KAFKA_VERSION "0.11.0.0"
ENV KAFKA_HOME "/opt/kafka/kafka_2.11-$KAFKA_VERSION"

ENV SERVER_CONF "$KAFKA_HOME/config/server.properties"

## 安装java
RUN yum -y  install wget tar java-1.8.0-openjdk \
    && mkdir -p /opt/kafka \
	&& wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/0.11.0.0/kafka_2.11-0.11.0.0.tgz -P /opt/kafka 

RUN tar zxvf /opt/kafka/kafka_2.11-0.11.0.0.tgz -C /opt/kafka \
	&& sed -i 's/num.partitions.*$/num.partitions=3/g' $SERVER_CONF \
	&& rm -rf /opt/kafka/kafka_2.11-0.11.0.0.tgz


RUN echo "cd $KAFKA_HOME" >> /opt/kafka/start.sh \
&& echo "sed -i 's%zookeeper.connect=.*$%zookeeper.connect=zookeeper:2181%g'  $SERVER_CONF " >> /opt/kafka/start.sh \
&& echo "sed -i 's/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/g' $SERVER_CONF " >> /opt/kafka/start.sh \

&& echo "[ ! -z $""BROKER_PORT"" ] && sed -i 's/#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092/advertised.listeners=PLAINTEXT:\/\/192.168.1.174:'$""BROKER_PORT'""/g' $SERVER_CONF" >> /opt/kafka/start.sh \

&& echo "[ ! -z $""BROKER_ID"" ] && sed -i 's/broker.id=0/broker.id='$""BROKER_ID'""/g' $SERVER_CONF " >> /opt/kafka/start.sh \

&& echo "bin/kafka-server-start.sh config/server.properties" >> /opt/kafka/start.sh \
&& chmod a+x /opt/kafka/start.sh

EXPOSE 9092

ENTRYPOINT ["sh", "/opt/kafka/start.sh"]
