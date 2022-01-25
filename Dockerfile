#
# Spark Standalone Container
# Apache Spark 3.2.0
#
# Runs a super-tiny, Spark standalone cluster in a container
# Suitable for building test/development containers for spark apps
#
# Usage:
# $ docker build -t uncharted/sparklet:3.2.0 .
# $ docker run -p 8080:8080 -it uncharted/sparklet:3.2.0

# Ubuntu 20.04 (focal)
# https://hub.docker.com/_/ubuntu/?tab=tags&name=focal
ARG ROOT_CONTAINER=ubuntu:focal

FROM $ROOT_CONTAINER

LABEL author="Sean McIntyre <smcintyre@uncharted.software>"

ARG spark_version="3.2.0"
ARG hadoop_version="3.2"
ARG spark_checksum="EBE51A449EBD070BE7D3570931044070E53C23076ABAD233B3C51D45A7C99326CF55805EE0D573E6EB7D6A67CFEF1963CD77D6DC07DD2FD70FD60DA9D1F79E5E"
ARG openjdk_version="11"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends "openjdk-${openjdk_version}-jre-headless" ca-certificates-java wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

# spark web admin ports
EXPOSE 4040
EXPOSE 8080

# spark debugging port
EXPOSE 9999

# Spark installation from: https://github.com/jupyter/docker-stacks/blob/master/pyspark-notebook/Dockerfile
WORKDIR /tmp
RUN wget -q "https://archive.apache.org/dist/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" && \
    echo "${spark_checksum} *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /opt --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /opt

RUN apt-get update --yes && \
    # grab curl and ssh
    apt-get install --yes openssh-client vim curl procps && \
    # generate a keypair and authorize it
    mkdir -p /root/.ssh && \
    ssh-keygen -f /root/.ssh/id_rsa -N "" && \
    cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && \
    # s6 overlay
    curl -LS https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz -o /tmp/s6-overlay.tar.gz && \
    tar xvfz /tmp/s6-overlay.tar.gz -C / && \
    rm -f /tmp/s6-overlay.tar.gz

# upload init scripts
ADD services/spark-master-run /etc/services.d/spark-master/run
ADD services/spark-slave-run /etc/services.d/spark-slave/run
ADD services/spark-slave2-run /etc/services.d/spark-slave2/run

ENV PATH "/opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin":$PATH

ENTRYPOINT [ "/init" ]

CMD ["spark-shell"]
