For development purposes, it is possible to run a development cluster on your local machine.
To do that, we will use https://github.com/Landoop/fast-data-dev.

Before you begin, ensure that you have at least **4GB** of ram allocated to the Docker engine. Anything lower might prevent the container from launching all of the dependent services. 

## Installation

Using Docker, issue the following command:

```console
docker run --rm -it -p 2181:2181 -p 3030:3030 -p 8081:8081 -p 8082:8082 -p 8083:8083 -p 9092:9092 -e ADV_HOST=127.0.0.1 landoop/fast-data-dev
```

It will start a docker container with the following services:

* 9092 : Kafka Broker
* 8081 : Schema Registry
* 8082 : Kafka REST Proxy
* 8083 : Kafka Connect Distributed
* 2181 : ZooKeeper
* 3030 : Web Server

The UI is accessible through http://localhost:3030/

## Create a topic

To create a topic, we will use the shell command `kafka-topics`. <br/>

### Run bash within the container 
```console
docker run --rm -it --net=host landoop/fast-data-dev bash
```
### Create the topic
```console
root@fast-data-dev / $ kafka-topics --zookeeper 127.0.0.1:2181 --create --topic clients.dev-local --partitions 10 --replication-factor 1
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic "clients.dev-local".
```
You should see the topic appear in the UI : http://localhost:3030/kafka-topics-ui/#/

## Push messages to the topic

Using Kafka console producer:

```console
root@fast-data-dev / $ kafka-console-producer \
  --broker-list localhost:9092 \
  --topic clients.dev-local \
  --property "parse.key=true" \
  --property "key.separator=:"
>0d779386-4544-470b-8bdb-18c97d4ae01a:{"uuid":"0d779386-4544-470b-8bdb-18c97d4ae01a","order":"1","updateTime":"2019-08-12T03:17:46.841Z"}
>
```
**NOTE**: The key-value format is enabled, so you have to respect the standard of `>key:value`

You should see your messages appear in the UI: http://localhost:3030/kafka-topics-ui/#/cluster/fast-data-dev/topic/n/my.first.topic/

## Consume messages from the topic

You can either use your application to connect to the broker `localhost:9092` or use the built-in `kafka-console-producer` shell. 

```console
root@fast-data-dev / $ kafka-console-consumer \
  --bootstrap-server 127.0.0.1:9092 \
  --topic clients.dev-local \
  --from-beginning
0d779386-4544-470b-8bdb-18c97d4ae01a:{"uuid":"0d779386-4544-470b-8bdb-18c97d4ae01a","order":"1","updateTime":"2019-08-12T03:17:46.841Z"}
```

### Delete test topics

```console
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic coyote-test-avro
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic coyote-test-binary
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic coyote-test-json
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic telecom_italia_data
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic backblaze_smart
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic nyc_yellow_taxi_trip_data
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic sea_vessel_position_reports
kafka-topics --zookeeper 127.0.0.1:2181 --delete --topic telecom_italia_grid
```



