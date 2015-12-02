#
# Spark Standalone Container
# Apache Spark 1.5.2
#
# Runs a super-tiny, Spark standalone cluster in a container
# Suitable for building test/development containers for spark apps
#
# Usage:
# $ docker build -t uncharted/sparklet .
# $ docker run -p 8080:8080 -it uncharted/sparklet

FROM debian:8.2
MAINTAINER Sean McIntyre <smcintyre@uncharted.software>

# spark web admin port
EXPOSE 8080
# spark debugging port
EXPOSE 9999

WORKDIR /opt
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  # grab curl, java and ssh
  apt-get install -y curl oracle-java8-installer openssh-client openssh-server && \
  curl http://apache.mirror.gtcomm.net/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz > spark.tgz && \
  # generate a keypair and authorize it
  mkdir -p /root/.ssh && \
  ssh-keygen -f /root/.ssh/id_rsa -N "" && \
  cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && \
  # extract spark
  tar -xzf spark.tgz && \
  # cleanup
  rm spark.tgz && \
  apt-get clean

# create startup script
ADD startup.sh /startup.sh
RUN chmod a+x /startup.sh

ENV PATH /opt/spark-1.5.2-bin-hadoop2.6/bin:$PATH

ENTRYPOINT ["/startup.sh"]

CMD ["spark-shell"]
