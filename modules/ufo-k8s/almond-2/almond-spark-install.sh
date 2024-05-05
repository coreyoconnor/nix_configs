#!/bin/sh
set -ex

almond_version=$1
scala_full_version=$2
spark_version=$3
ammonite_spark_version=$4
kernel_id=$5
kernel_desc=$6
spark_cluster=$7
spark_cluster_name=$8

coursier launch --fork almond:${almond_version} --scala ${scala_full_version} \
      -- --install --id ${kernel_id} --display-name "${kernel_desc}" \
      --jupyter-path /opt/conda/share/jupyter/kernels \
      --global \
      --arg /opt/conda/share/jupyter/kernels/${kernel_id}/launcher \
      --arg --predef --arg /etc/spark-predef.scala #\
      #--arg --toree-compatibility

coursier bootstrap almond:${almond_version} --scala ${scala_full_version} \
      --output /opt/conda/share/jupyter/kernels/${kernel_id}/launcher \
      --jvm-option-file /etc/spark-jvm-opts.txt

