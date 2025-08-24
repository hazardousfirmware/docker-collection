#!/bin/bash

workdir=/tmp/workdir/

mkdir -p ${workdir}

cd ${workdir}

docker run -v ${PWD}:/project -u ${UID} -it fedora-intel-opencl-legacy-compile:latest
