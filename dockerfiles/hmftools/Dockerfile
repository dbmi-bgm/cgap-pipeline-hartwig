#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
MAINTAINER Dominika Maziec (dominika_maziec@hms.harvard.edu)


RUN apt-get update && \
    apt-get install -y openjdk-11-jdk ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME
#RUN add-apt-repository -y ppa:linuxuprising/java 
#RUN conda install -c "bioconda/label/cf201901" java-jdk

# Setup JAVA_HOME -- useful for docker commandline

# JAVA
# /usr/lib/jvm/java-11-openjdk-amd64/bin/java

COPY amber-3.9.jar .