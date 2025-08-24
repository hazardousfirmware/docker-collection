#!/bin/bash

docker build -t "fedora-intel-opencl-legacy-compile" --build-arg USER_ID=$(id -u) .

workdir=/tmp/workdir/

mkdir -p ${workdir}

cd ${workdir}

docker run -v ${PWD}:/project -u ${UID} -it fedora-intel-opencl-legacy-compile:latest
