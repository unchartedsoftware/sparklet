#
# Spark Standalone Container
# Apache Spark 1.5.1
#
# Runs a simple, single-node Spark cluster in a container
#
# Usage:
# $ docker build -t docker.uncharted.software/tiny-spark-standalone .
# $ docker run -it docker.uncharted.software/tiny-spark-standalone bash

FROM debian:8.2
MAINTAINER Sean McIntyre <smcintyre@uncharted.software>

WORKDIR /opt
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  # grab curl and java
  apt-get install -y curl oracle-java8-installer && \
  curl http://mirror.csclub.uwaterloo.ca/apache/spark/spark-1.5.1/spark-1.5.1-bin-hadoop2.6.tgz > spark.tgz && \
  # extract spark
  tar -xzf spark.tgz && \
  # cleanup
  rm spark.tgz && \
  apt-get clean

ENV PATH /opt/spark-1.5.1-bin-hadoop2.6/bin:$PATH
