#!/bin/sh
echo "********************************************************"
echo "Waiting for the eureka server to start                 *"
echo "********************************************************"
while ! `nc -z eurekaserver 8761`; do sleep 3; done
echo "******* Eureka Server has started"


echo "********************************************************"
echo "Waiting for the database server to start"              *"
echo "********************************************************"
while ! `nc -z database 5432`; do sleep 3; done
echo "******** Database Server has started"

echo "********************************************************"
echo "Waiting for the configuration server to start"         *"
echo "********************************************************"
while ! `nc -z configserver 8888`; do sleep 3; done
echo "*******  Configuration Server has started"

echo "********************************************************"
echo "Waiting for the kafka server to start                 *"
echo "********************************************************"
while ! `nc -z kafkaserver 9092`; do sleep 10; done
echo "******* Kafka Server has started"

echo "********************************************************"
echo "Waiting for the zookeeper server to start                 *"
echo "********************************************************"
while ! `nc -z kafkaserver 2181`; do sleep 10; done
echo "******* Zookeeper has started"

echo "********************************************************"
echo "Starting License Server with Configuration Service via Eureka :  $EUREKASERVER_URI:$SERVER_PORT"
echo "Using Kafka Server: $KAFKASERVER_URI"
echo "Using ZK    Server: $ZKSERVER_URI"
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom -Dserver.port=$SERVER_PORT   \
     -Deureka.client.serviceUrl.defaultZone=$EUREKASERVER_URI             \
     -Dspring.cloud.config.uri=$CONFIGSERVER_URI                          \
     -Dspring.cloud.stream.kafka.binder.zkNodes=$KAFKASERVER_URI          \
     -Dspring.cloud.stream.kafka.binder.brokers=$ZKSERVER_URI             \
     -Dspring.profiles.active=$PROFILE -jar /usr/local/licensingservice/licensing-service-0.0.1-SNAPSHOT.jar
