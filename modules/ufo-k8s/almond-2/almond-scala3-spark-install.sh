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
      --arg --predef --arg /etc/scala3-spark-predef.scala #\
      #--arg --toree-compatibility

coursier bootstrap almond:${almond_version} --scala ${scala_full_version} \
      --output /opt/conda/share/jupyter/kernels/${kernel_id}/launcher \
      --jvm-option-file /etc/spark-jvm-opts.txt

coursier fetch --scala 3 org.apache.spark:spark-sql_2.13:${spark_version}
coursier fetch --scala 3 sh.almond:ammonite-spark_2.13:${ammonite_spark_version}
coursier fetch --scala 3 org.scala-lang.modules::scala-xml:2.3.0

