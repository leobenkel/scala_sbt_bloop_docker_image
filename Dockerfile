FROM openjdk:8

MAINTAINER Leo Benkel

ARG SBT_VERSION
ARG SCALA_VERSION

RUN apt update && apt install -y wget make vim apt-transport-https

# Install SBT
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && apt update \
    && apt install sbt

# Install Scala
RUN export TMP_INSTALL_FOLDER="/tmp/install" \
    && mkdir -p ${TMP_INSTALL_FOLDER}/project \
    && echo "sbt.version = ${SBT_VERSION}" > ${TMP_INSTALL_FOLDER}/project/build.properties \
    && echo "scalaVersion := \"${SCALA_VERSION}\"" > ${TMP_INSTALL_FOLDER}/build.sbt \
    && cd ${TMP_INSTALL_FOLDER} \
    && sbt ";reload ;update ;compile" \
    && echo "SbtVersion: " \
    && sbt sbtVersion \
    && echo "ScalaVersion: " \
    && sbt scalaVersion \
    && rm -fr ${TMP_INSTALL_FOLDER} \
    && unset TMP_INSTALL_FOLDER

# Install coursier
RUN export TMP_INSTALL_FOLDER="/tmp/coursier" \
    && mkdir -p ${TMP_INSTALL_FOLDER} \
    && curl -fLo ${TMP_INSTALL_FOLDER}/cs https://git.io/coursier-cli-linux \
    && chmod +x ${TMP_INSTALL_FOLDER}/cs \
    && cp ${TMP_INSTALL_FOLDER}/cs /usr/local/bin/coursier \
    && cp ${TMP_INSTALL_FOLDER}/cs /usr/local/bin/cs \
    && rm -fr ${TMP_INSTALL_FOLDER} \
    && unset TMP_INSTALL_FOLDER

# Install yaourt
# https://archlinux.fr/yaourt-en
RUN coursier install bloop --only-prebuilt=true \
    && echo '' >> /root/.bashrc \
    && echo '#Bloop' >> /root/.bashrc \
    && echo 'export PATH="$PATH:/root/.local/share/coursier/bin"' >> /root/.bashrc \
    && . /root/.bashrc

