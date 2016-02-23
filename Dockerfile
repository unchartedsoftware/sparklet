#
# Spark Standalone Container
# Apache Spark 1.6.0
#
# Runs a super-tiny, Spark standalone cluster in a container
# Suitable for building test/development containers for spark apps
#
# Usage:
# $ docker build -t uncharted/sparklet .
# $ docker run -p 8080:8080 -it uncharted/sparklet

FROM anapsix/alpine-java:latest
MAINTAINER Sean McIntyre <smcintyre@uncharted.software>

# spark web admin port
EXPOSE 8080

# spark debugging port
EXPOSE 9999

WORKDIR /opt

RUN \
  # update packages
  apk upgrade --update && \
  # grab curl and ssh
  apk add --update vim curl procps && \
  curl http://apache.mirror.gtcomm.net/spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz > spark.tgz && \
  # generate a keypair and authorize it
  mkdir -p /root/.ssh && \
  ssh-keygen -f /root/.ssh/id_rsa -N "" && \
  cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && \
  # extract spark
  tar -xzf spark.tgz && \
  # cleanup
  rm spark.tgz

ENV PATH /opt/spark-1.6.0-bin-hadoop2.6/bin:$PATH
ENV JAVA_HOME /opt/jdk

ADD startup.sh /startup.sh
RUN chmod a+x /startup.sh

ENTRYPOINT [ "/startup.sh" ]

CMD ["spark-shell"]
