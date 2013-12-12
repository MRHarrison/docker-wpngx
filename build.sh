#!/bin/bash

. ./docker-wpngx.conf

docker build -t "$REPOSITORY:$TAG" .
