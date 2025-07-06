#!/bin/bash

docker run -v ${PWD}:/project -u ${UID} -it arm-compiler:latest
