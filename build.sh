#!/bin/bash
NAME=$(cat app.name)
docker build -t sullof/wpngx:$NAME .
