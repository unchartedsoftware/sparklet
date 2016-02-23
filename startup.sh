#!/bin/bash
echo "spark.master  spark://$HOSTNAME:7077" > /opt/spark-1.5.2-bin-hadoop2.6/conf/spark-defaults.conf

/opt/spark-1.5.2-bin-hadoop2.6/sbin/start-master.sh
SPARK_WORKER_INSTANCES=2 /opt/spark-1.5.2-bin-hadoop2.6/sbin/start-slave.sh spark://$HOSTNAME:7077
eval $1
