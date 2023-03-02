#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
MAINTAINER Dominika Maziec (dominika_maziec@hms.harvard.edu)

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin


RUN apt-get update && \
    apt-get install -y openjdk-11-jdk ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f

RUN conda install -c bioconda -y r-base==4.1.0 gridss

RUN R -e "install.packages('dplyr', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install('copynumber')"
RUN R -e "BiocManager::install('VariantAnnotation')"
RUN R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('cowplot', repos='http://cran.rstudio.com/')"

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME


#RUN add-apt-repository -y ppa:linuxuprising/java 
#RUN conda install -c "bioconda/label/cf201901" java-jdk

# Setup JAVA_HOME -- useful for docker commandline

# JAVA
# /usr/lib/jvm/java-11-openjdk-amd64/bin/java

COPY amber-3.9.jar .
COPY cobalt-1.13.jar .
COPY purple_v3.8.1.jar .
COPY linx_v1.22.jar .
COPY scripts/run_hmftools.sh .
COPY scripts/run_amber.sh . 
COPY circos-0.69-9.tgz .

RUN tar -xf circos-0.69-9.tgz

RUN chmod +x run_hmftools.sh
RUN chmod +x run_amber.sh