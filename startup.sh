#!/bin/bash
echo "spark.master  spark://$HOSTNAME:7077" > /opt/spark-1.4.1-bin-hadoop2.6/conf/spark-defaults.conf
service ssh restart
/opt/spark-1.4.1-bin-hadoop2.6/sbin/start-master.sh
SPARK_WORKER_INSTANCES=2 /opt/spark-1.4.1-bin-hadoop2.6/sbin/start-slave.sh spark://$HOSTNAME:7077
eval $1
