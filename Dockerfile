FROM ubuntu:14.04


MAINTAINER pavan.git@gmail.com

RUN apt-get update

# This step will install java 8 on the image
RUN apt-get install software-properties-common -y \
&&  apt-add-repository ppa:webupd8team/java -y \
&&  apt-get update -y \

#this step will agree and install java 8
&&  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections \
&&  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections \

#this step will install java and supervisor
&&  apt-get install -y oracle-java8-installer \
    supervisor


#downloading & unpacking Spark 2.3.0
RUN wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz \
&&  tar -xzf spark-2.3.0-bin-hadoop2.7.tgz \
&&  mv spark-2.3.0-bin-hadoop2.7 /opt/spark


# adding conf files to all images. This will be used in supervisord for running spark master/slave
COPY master.conf /opt/conf/master.conf
COPY slave.conf /opt/conf/slave.conf


# expose port 8080 for spark UI
EXPOSE 8080

#default command: this is just an option 
CMD ["/opt/spark/bin/spark-shell", "--master", "local[*]"]
