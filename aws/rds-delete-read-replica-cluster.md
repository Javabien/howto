# Delete a read replica cluster

If you try to delete a read replica cluster directly, you will get this error:
> An error occurred (InvalidDBClusterStateFault) when calling the DeleteDBCluster operation: Cluster cannot be deleted, it still contains DB instances in non-deleting state.

If you try to delete a read replica instance directly, you will get this error:

> An error occurred (InvalidDBClusterStateFault) when calling the DeleteDBInstance operation: Cannot delete the last instance of the read replica DB cluster. Promote the DB cluster to a standalone DB cluster in order to delete it.

# Procedure
## Step 1 - Promote the read replica cluster

### AWS Console
Select the cluster, then click on `Action` and `Promote`

= OR =

### AWS cli
```
aws rds promote-read-replica-db-cluster \
   --db-cluster-identifier poc-cluster-us-east-1
```

## Step 2 - Delete the read reaplica instance

### AWS Console
Select the instance, then click on `Action` and `Delete`

= OR =

### AWS cli
```
aws rds delete-db-instance \
   --db-instance-identifier poc-instance-us-east-1 \
   --skip-final-snapshot
```

## Step 3 - Delete the read reaplica cluster

### AWS Console
Select the cluster, then click on `Action` and `Delete`

= OR =

### AWS cli
```
aws rds delete-db-cluster \
   --db-cluster-identifier poc-cluster-us-east-1 \
   --skip-final-snapshot
```
