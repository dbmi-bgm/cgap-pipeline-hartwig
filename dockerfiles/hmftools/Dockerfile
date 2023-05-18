#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

#######################################################################
#     Setting working env
#######################################################################
ENV WORKDIR=/usr/local/bin
ENV AMBER_JAR=amber-3.9.jar
ENV COBALT_JAR=cobalt-1.13.jar
ENV PURPLE_JAR=purple_v3.8.1.jar
ENV LINX_JAR=linx_v1.22.jar

ENV AMBER_JAR_PATH=${WORKDIR}/${AMBER_JAR}
ENV COBALT_JAR_PATH=${WORKDIR}/${COBALT_JAR}
ENV PURPLE_JAR_PATH=${WORKDIR}/${PURPLE_JAR}
ENV LINX_JAR_PATH=${WORKDIR}/${LINX_JAR}

WORKDIR ${WORKDIR}


RUN apt-get update && \
    apt-get install -y openjdk-11-jdk ca-certificates-java tabix && \
    apt-get clean && \
    update-ca-certificates -f

RUN conda install -c bioconda -y r-base==4.1.0

RUN R -e "install.packages('dplyr', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install('copynumber')"
RUN R -e "BiocManager::install('VariantAnnotation')"
RUN R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('cowplot', repos='http://cran.rstudio.com/')"
RUN pip install granite-suite

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

COPY software/${AMBER_JAR} .
COPY software/${COBALT_JAR} .
COPY software/${PURPLE_JAR} .
COPY software/${LINX_JAR} .
COPY software/circos-0.69-9.tgz .

COPY scripts/run_hmftools.sh .
COPY scripts/filter_variants.py .
COPY scripts/remove_non_std_chroms.py .

RUN tar -xf circos-0.69-9.tgz

RUN chmod +x run_hmftools.sh