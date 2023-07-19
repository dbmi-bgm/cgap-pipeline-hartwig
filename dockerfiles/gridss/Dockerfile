#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

#######################################################################
#     Setting working env
#######################################################################
ENV WORKDIR=/usr/local/bin

ENV GRIDSS_JAR=gridss-2.13.2.jar
ENV GRIPSS_JAR=gripss_v2.3.3.jar

ENV GRIDSS_JAR_PATH=${WORKDIR}/${GRIDSS_JAR}
ENV GRIPSS_JAR_PATH=${WORKDIR}/${GRIPSS_JAR}

WORKDIR ${WORKDIR}

RUN apt-get update && \
    apt-get install -y openjdk-11-jdk=11.0.19+7~us1-0ubuntu1~20.04.1 \
    ca-certificates-java=20190405ubuntu1 \
    util-linux=2.34-0.1ubuntu9.3 \
    tabix=1.10.2-3ubuntu0.1 \
    locales=2.31-0ubuntu9.9 \
    libarchive-tools=3.4.0-2ubuntu1.2 \
    zlib1g-dev=1:1.2.11.dfsg-2ubuntu1.5 \
    liblz4-tool=1.9.2-2ubuntu0.20.04.1 \
    libcurl4-openssl-dev=7.68.0-1ubuntu2.19\
    libssl-dev=1.1.1f-1ubuntu2.19 \
    zip=3.0-11build1 \
    libarchive-tools=3.4.0-2ubuntu1.2 \
    libncurses5-dev  \
    libbz2-dev=1.0.8-2 \
    liblzma-dev=5.2.4-1ubuntu1.1  \
    --no-install-recommends && \
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates -f

## samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.13/samtools-1.13.tar.bz2 && \
    tar -xjf samtools-1.13.tar.bz2 && \
    rm -rf samtools-1.13.tar.bz2
WORKDIR ${WORKDIR}/samtools-1.13
RUN ./configure && \
    make
WORKDIR ${WORKDIR}
RUN ln -s samtools-1.13 samtools

## bwa
RUN wget https://github.com/lh3/bwa/archive/v0.7.17.tar.gz && \
    tar -xzf v0.7.17.tar.gz && \
    rm -rf v0.7.17.tar.gz
WORKDIR ${WORKDIR}/bwa-0.7.17
RUN make
WORKDIR ${WORKDIR}
RUN ln -s bwa-0.7.17 bwa

RUN conda install -c bioconda -y r-base==4.1.0

COPY software/${GRIDSS_JAR} .
COPY software/${GRIPSS_JAR} .

COPY software/gridss . 
RUN chmod +x gridss

COPY scripts/run_gridss_gripss.sh . 
RUN chmod +x run_gridss_gripss.sh

ENV PATH="${PATH}:${WORKDIR}/samtools:${WORKDIR}/gridss:${WORKDIR}/bwa"
