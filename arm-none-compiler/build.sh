#!/bin/bash

docker build -t "arm-compiler" --build-arg USER_ID=$(id -u) .
