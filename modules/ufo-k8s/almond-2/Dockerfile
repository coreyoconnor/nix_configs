ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_CONTAINER=$REGISTRY/$OWNER/scipy-notebook
FROM $BASE_CONTAINER

# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Spark dependencies
# Default values can be overridden at build time
# (ARGS are in lowercase to distinguish them from ENV)
ARG openjdk_version="17"

# If spark_version is not set, latest stable Spark will be installed
ARG spark_version="3.5.1"
ARG hadoop_version="3"
ARG scala2_version="2.13"
ARG scala2_full_version="2.13.11"
ARG scala3_version="3.3"
ARG scala3_full_version="3.3.0"
ARG almond_version="0.14.0-RC7"
ARG ammonite_spark_version="0.14.0-RC8"

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java \
    fonts-dejavu \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# URL to use for Spark downloads
# You need to use https://archive.apache.org/dist/spark/ website if you want to download old Spark versions
# But it seems to be slower, that's why we use the recommended site for download
ARG spark_download_url="https://dlcdn.apache.org/spark/"

ENV SPARK_HOME=/usr/local/spark
ENV PATH="${PATH}:${SPARK_HOME}/bin"
ENV SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info"

COPY setup_spark.py /opt/setup-scripts/

# Setup Spark
RUN /opt/setup-scripts/setup_spark.py \
    --spark-version="${spark_version}" \
    --hadoop-version="${hadoop_version}" \
    --scala-version="${scala2_version}" \
    --spark-download-url="${spark_download_url}"

# RSpark config
ENV R_LIBS_USER "${SPARK_HOME}/R/lib"
RUN fix-permissions "${R_LIBS_USER}"

# Configure IPython system-wide
COPY ipython_kernel_config.py "/etc/ipython/"
RUN fix-permissions "/etc/ipython/"

# configure and setup coursier
ENV COURSIER_CACHE=/usr/share/coursier/cache

RUN mkdir -p $COURSIER_CACHE && \
    chgrp -R users $COURSIER_CACHE && \
    chmod -R g+rwxs $COURSIER_CACHE

RUN curl -Lo /bin/coursier https://git.io/coursier-cli && \
    chmod +x /bin/coursier

COPY spark-jvm-opts.txt /etc/spark-jvm-opts.txt
COPY scala2-spark-predef.scala /etc/scala2-spark-predef.scala
COPY scala3-spark-predef.scala /etc/scala3-spark-predef.scala
COPY scala3-lamp-predef.scala /etc/scala3-lamp-predef.scala
COPY ipython_config.py /etc/ipython/ipython_config.py

COPY almond-install.sh /bin/almond-install.sh
RUN chmod +x /bin/almond-install.sh

COPY almond-scala2-spark-install.sh /bin/almond-scala2-spark-install.sh
RUN chmod +x /bin/almond-scala2-spark-install.sh

COPY almond-scala3-spark-install.sh /bin/almond-scala3-spark-install.sh
RUN chmod +x /bin/almond-scala3-spark-install.sh

COPY almond-scala3-lamp-install.sh /bin/almond-scala3-lamp-install.sh
RUN chmod +x /bin/almond-scala3-lamp-install.sh

ARG spark_cluster="local[*]"
ARG spark_cluster_name="Local"

USER ${NB_UID}

RUN /bin/almond-scala2-spark-install.sh ${almond_version} ${scala2_full_version} \
      ${spark_version} ${ammonite_spark_version} \
      scala2spark3 "Scala 2 with Spark cluster ${spark_cluster_name}" \
      "${spark_cluster}" "${spark_cluster_name}"

RUN /bin/almond-scala3-spark-install.sh ${almond_version} ${scala3_full_version} \
      ${spark_version} ${ammonite_spark_version} \
      scala3spark3 "Scala 3 with Spark cluster ${spark_cluster_name}" \
      "${spark_cluster}" "${spark_cluster_name}"

RUN /bin/almond-install.sh ${almond_version} ${scala2_full_version} scala2 "Scala 2"

RUN /bin/almond-install.sh ${almond_version} ${scala3_full_version} scala3 "Scala 3"

RUN /bin/almond-scala3-lamp-install.sh ${almond_version} ${scala3_full_version} \
      scala3lamp "Scala 3 with Lamp"

# Install pyarrow
# NOTE: It's important to ensure compatibility between Pandas versions.
# The pandas version in this Dockerfile should match the version
# on which the Pandas API for Spark is built.
# To find the right version:
# 1. Check out the Spark branch you are on: <https://github.com/apache/spark>
# 2. Find the pandas version in the file `dev/infra/Dockerfile`.
RUN mamba install --yes \
    'grpcio-status' \
    'grpcio' \
    'pandas=2.0.3' \
    'pyarrow' \
    'r-base' \
    'r-ggplot2' \
    'r-irkernel' \
    'r-rcurl' \
    'r-sparklyr' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install PyTorch with pip (https://pytorch.org/get-started/locally/)
# hadolint ignore=DL3013
RUN pip install --no-cache-dir --index-url 'https://download.pytorch.org/whl/cpu' \
    'torch' \
    'torchvision' \
    'torchaudio'  && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

ENV LD_LIBRARY_PATH /opt/conda/lib/python3.11/site-packages/torch/lib

WORKDIR "${HOME}"
EXPOSE 4040

