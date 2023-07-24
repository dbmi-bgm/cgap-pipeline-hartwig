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
    apt-get install -y openjdk-11-jdk=11.0.19+7~us1-0ubuntu1~20.04.1 \
    ca-certificates-java=20190405ubuntu1.1 \
    tabix=1.10.2-3ubuntu0.1 && \
    apt-get clean && \
    update-ca-certificates -f

RUN conda install -c bioconda -y r-base==4.1.0

RUN R -e "install.packages('dplyr', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install('copynumber')"
RUN R -e "BiocManager::install('VariantAnnotation')"
RUN R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('cowplot', repos='http://cran.rstudio.com/')"

RUN pip install granite-suite==0.2.0

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

RUN wget https://github.com/hartwigmedical/hmftools/releases/download/amber-v3.9/amber-3.9.jar
RUN wget https://github.com/hartwigmedical/hmftools/releases/download/cobalt-v1.13/cobalt-1.13.jar
RUN wget https://github.com/hartwigmedical/hmftools/releases/download/purple-v3.8.1/purple_v3.8.1.jar
RUN wget https://github.com/hartwigmedical/hmftools/releases/download/linx-v1.22/linx_v1.22.jar
RUN wget http://circos.ca/distribution/circos-0.69-9.tgz

COPY scripts/run_hmftools.sh .
COPY scripts/filter_variants.py .
COPY scripts/remove_non_std_chroms.py .
COPY scripts/check_samples_order_vcf.py .

RUN tar -xf circos-0.69-9.tgz

RUN chmod +x run_hmftools.sh