FROM cgap/cgap-ubuntu2004-py-38:0.0.1

LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

ENV WORKDIR=/usr/local/bin

WORKDIR ${WORKDIR}

RUN pip install granite-suite==0.2.0

COPY scripts/bnd2bedpe.py .
