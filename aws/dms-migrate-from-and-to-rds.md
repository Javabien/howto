# Migrate from and to RDS

## Create replication instance

```console
aws dms create-replication-instance \
--replication-instance-identifier poc-migration \
--allocated-storage 50 \
--replication-instance-class dms.t2.medium \
--vpc-security-group-ids sg-1 sg-2 sg-3 \
--replication-subnet-group-identifier default-vpc-a \
--no-multi-az \
--tags Key=Operation,Value=migration
--kms-key-id arn:aws:kms:us-west-2:123:key/4124330f-855e-4e7d-9e85-e0ecb2a8745f \
--no-publicly-accessible
```

## Create source and target endpoints

```console
aws dms create-endpoint \
--endpoint-identifier poc-source-mysql \
--endpoint-type source \
--engine-name aurora \
--server-name poc-cluster.cluster-ckaasdf3.us-west-2.rds.amazonaws.com \
--port 3306 \
--username admin \
--password [PASSWORD]
```

```console
aws dms create-endpoint \
--endpoint-identifier poc-target-postgres \
--endpoint-type target \
--engine-name aurora-postgresql \
--server-name poc-postgres-cluster.cluster-ckaadfg.us-west-2.rds.amazonaws.com \
--port 5432 \
--database-name clients \
--username admin \
--password [PASSWORD]
```

**Note:** Make sure the DB `clients` already exists or the connection will fail:
```sql
CREATE DATABASE clients
  WITH OWNER = admin
       ENCODING = 'UTF8'
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;
```

## Test connection from replication instance to endpoints

### Source
```console
aws dms test-connection \
--replication-instance-arn arn:aws:dms:us-west-2:123:rep:FASDF13241fASDFR42 \
--endpoint-arn arn:aws:dms:us-west-2:123:endpoint:JYDGBDBS2DSFG634DF

aws dms wait test-connection-succeeds \
--filters Name=endpoint-arn,Values=arn:aws:dms:us-west-2:123:endpoint:JYDGBDBS2DSFG634DF
```

### Target
```console
aws dms test-connection \
--replication-instance-arn arn:aws:dms:us-west-2:123:rep:QPKSNFEJVHAD \
--endpoint-arn arn:aws:dms:us-west-2:123:endpoint:POAKSDFNBVZAFK31LA

aws dms wait test-connection-succeeds \
--filters Name=endpoint-arn,Values=arn:aws:dms:us-west-2:123:endpoint:POAKSDFNBVZAFK31LA
```

In case the test fails, the response will say:
> Waiter TestConnectionSucceeds failed: Waiter encountered a terminal failure state


## Create replication task
```console
aws dms create-replication-task \
--replication-task-identifier poc-mysql-to-postgres
--source-endpoint-arn arn:aws:dms:us-west-2:123:endpoint:JYDGBDBS2DSFG634DF \
--target-endpoint-arn arn:aws:dms:us-west-2:123:endpoint:POAKSDFNBVZAFK31LA \
--replication-instance-arn arn:aws:dms:us-west-2:123:rep:BS3IYAUSGPNXMQAENH2XWM7IEQ \
--migration-type full-load \
--table-mappings "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"clients\",\"table-name\":\"%\"},\"rule-action\":\"include\",\"filters\":[]}]}"
```

Article: [Automation Framework for AWS Database Migration Services](https://github.com/awslabs/aws-database-migration-tools/tree/master/Blogs/DMS%20Automation%20Framework)
