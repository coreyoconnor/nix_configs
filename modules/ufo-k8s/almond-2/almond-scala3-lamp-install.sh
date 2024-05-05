#!/bin/sh
set -ex

almond_version=$1
scala_full_version=$2
kernel_id=$3
kernel_desc=$4

coursier launch --fork almond:${almond_version} --scala ${scala_full_version} \
      -- --install --id ${kernel_id} --display-name "${kernel_desc}" \
      --jupyter-path /opt/conda/share/jupyter/kernels \
      --global \
      --arg /opt/conda/share/jupyter/kernels/${kernel_id}/launcher \
      --arg --predef --arg /etc/scala3-lamp-predef.scala #\
      #--arg --toree-compatibility

coursier bootstrap almond:${almond_version} --scala ${scala_full_version} \
      --output /opt/conda/share/jupyter/kernels/${kernel_id}/launcher \
      --jvm-option-file /etc/spark-jvm-opts.txt

LAMP_VERSION=0.0.111

coursier fetch --scala 3 io.github.pityka::lamp-sten:${LAMP_VERSION}
coursier fetch --scala 3 io.github.pityka::lamp-core:${LAMP_VERSION}
coursier fetch --scala 3 io.github.pityka::lamp-data:${LAMP_VERSION}
coursier fetch --scala 3 io.github.pityka::lamp-saddle:${LAMP_VERSION}

