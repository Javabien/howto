# kafka-console-consumer

## Extract data
```
kafka-console-consumer \
--bootstrap-server platform-kafka.test.com:80 \
--from-beginning \
--topic clients \
| jq .uuid
```
# kafka-consumer-groups

## Reset offsets to earliest
```console
kafka-consumer-groups \
--bootstrap-server kafka-host:9092 \
--group postgres-index \
--reset-offsets --to-earliest \
--topic clients \
--execute
```

## Reset offsets to latest
```console
kafka-consumer-groups \
--bootstrap-server kafka-host:9092 \
--group postgres-index \
--reset-offsets --to-latest \
--topic clients \
--execute
```
