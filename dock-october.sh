#!/bin/bash

#check if docker and docker-compose is installed
type docker >/dev/null 2>&1 || { echo >&2 "I require docker and docker-compose but it's not installed.  Aborting."; exit 1; }
type docker-compose >/dev/null 2>&1 || { echo >&2 "I require docker and docker-compose but it's not installed.  Aborting."; exit 1; }

#ensure the script will work even through $PATH or different location
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

#check if script is run by effective user UID = 0 (root, or sudo)
if [ "x`echo $EUID|tr -d ' '`" != "x0" ]; then
    echo "We need root privileges to run the stuff"
    exit 2
fi

#validate params number
if [ "x`echo $#|tr -d ' '`" != "x2" ] && [ "x`echo $#|tr -d ' '`" != "x3" ]; then
    echo "Usage: $0 [projectname] <domain> <username>"
    echo "Params:"
    echo "projectname: only small letters, if not supplied, dir name used"
    echo "domain: your local domain to add to /etc/hosts file"
    echo "username: your local user name which will edit the project"
    exit 1
fi

#get project_name from directory name if not supplied
if [ "x`echo $#|tr -d ' '`" == "x3" ]; then
    project_name=$1
    project_domain=$2
    username=$3
else
    project_name=${PWD##*/}
    project_domain=$1
    username=$2
fi

#check if project_name contains only small letters (for easier managing)
if [[ "$project_name" =~ [^a-z\ ] ]]; then
    echo "Use only small latin letters in project name"
    exit 3
fi

#Core functionality of script

name_suffix="_web_1"
container_name=$project_name$name_suffix

uid=`id -u $username`

function createdirs() {
    if [ ! -d "$DIR/source" ]; then
        mkdir $DIR/source
    fi
    if [ ! -d "$DIR/mysqldata" ]; then
        mkdir $DIR/mysqldata
    fi
}

function createdockerconf() {
    cp $DIR/stubs/docker-compose.stub $DIR/docker-compose.yml
    sed -i "s/<<PROJECT_NAME>>/$project_name/g" $DIR/docker-compose.yml
    sed -i "s/<<PROJECT_DOMAIN>>/$project_domain/g" $DIR/docker-compose.yml
    sed -i "s/<<UID>>/$uid/g" $DIR/docker-compose.yml
}

function addtohosts() {
    host_ip=$1
    project_url=$2

    #add the record only if it does not exist
    if test -z "`grep -i $project_url /etc/hosts`"; then
        hosts_line="$host_ip $project_url"
        echo $hosts_line >> /etc/hosts
    fi
}

#Let's roll
if [ ! -e "$DIR/docker-compose.yml" ]; then
    createdirs

    createdockerconf

    project_url="$project_name.$project_domain"
    addtohosts "127.0.0.1" $project_url
    addtohosts "127.0.0.1" "phpmyadmin.$project_url"

else
    echo "docker-compose.yml exists"
    echo "Now you should probably run docker-compose start"
    exit 0
fi
