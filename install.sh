#!/usr/bin/env bash
set -e

if [ -z $SBT_VERSION ]; then
    echo "You need to define SBT_VERSION"
    exit 1
fi

if [ -z $SCALA_VERSION ]; then
    echo "You need to define SCALA_VERSION"
    exit 1
fi

GIT_SHA=$(git rev-parse --short HEAD)

docker build \
    -t leobenkel/scala_sbt_bloop:${GIT_SHA}-${SBT_VERSION}-${SCALA_VERSION} \
    --build-arg SBT_VERSION=${SBT_VERSION} \
    --build-arg SCALA_VERSION=${SCALA_VERSION} \
    -f Dockerfile \
    .
