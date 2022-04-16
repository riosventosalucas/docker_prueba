#!/bin/bash

clear

VERSION="1.0.0"
WORKDIR=$(pwd)
DOCKER_DAEMON=$(which docker)

echo -e "[ INFO ] SCRIPT VERSION: $VERSION\n"
echo -e "\t[ INFO ] WORKDIR: $WORKDIR"
echo -e "\t[ INFO ] DOCKER_DAEMON: $DOCKER_DAEMON"


echo -e "\n[ INFO ] Buscando contenedores"
CONTAINERS=$(docker ps -aq)

for container in $CONTAINERS
do
	echo -e "\t[ INFO ] Eliminando contenedor ID $($DOCKER_DAEMON rm -f $container)"
done

echo -e "[ INFO ] Eliminando imagenes..."

IMAGES=$(docker image ls -aq)

for image in $IMAGES
do
	echo -e "\t[ INFO ] Eliminando image ID $($DOCKER_DAEMON image rm -f $image > /dev/null 2>&1 )"
done