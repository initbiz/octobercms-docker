#!/bin/bash

if [ "x`echo $#|tr -d ' '`" != "x0" ] && [ "x`echo $#|tr -d ' '`" != "x1" ]; then
    echo "Usage: $0 [projectname]"
    exit 1
fi

if [ "x`echo $EUID|tr -d ' '`" != "x0" ]; then
    echo "We need root privileges to run the stuff"
    exit 2
fi

if [ "x`echo $#|tr -d ' '`" == "x1" ]; then
    project_name=$1
else
    project_name=${PWD##*/}
fi

name_suffix="_web_1"
container_name=$project_name$name_suffix

docker exec -i -t $container_name /bin/bash
