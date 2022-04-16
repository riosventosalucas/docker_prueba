#!/bin/bash

clear

VERSION="1.0.0"
APP_NAME="frontendapp"
WORKDIR=$(pwd)
DOCKER_DAEMON=$(which docker)
CURRENT_VERSION=0
LOCAL_PORT=8000
REMOTE_PORT=80

echo -e "[ INFO ] SCRIPT VERSION: $VERSION\n"
echo -e "\t[ INFO ] APPNAME: $APP_NAME"
echo -e "\t[ INFO ] WORKDIR: $WORKDIR"
echo -e "\t[ INFO ] DOCKER_DAEMON: $DOCKER_DAEMON"

echo -e "\n[ INFO ] Buscando versiones anteriores..."

ALREADY_EXIST=$(docker image ls | grep $APP_NAME)

if [[ -z $ALREADY_EXIST ]]; then
	echo -e "\t[ NOTICE ] Ninguna version anterior encontrada"
	echo -e "\t[ INFO ] Configurando version en 1."
	CURRENT_VERSION=1
	NEW_VERSION=$CURRENT_VERSION
	echo -e "FROM nginx:alpine

COPY dist/ /usr/share/nginx/html" > $WORKDIR/Dockerfile

else
	CURRENT_VERSION=$(docker image ls | grep $APP_NAME | awk '{print $2}' | sort | tail -1)
	NEW_VERSION=$((CURRENT_VERSION+1))
	sed -i "s/nginx\:alpine/$APP_NAME:$CURRENT_VERSION/g" $WORKDIR/Dockerfile
fi


echo -e "\n[ INFO ] Creando imagen..."
echo -e "\t[ INFO ] Version actual: $CURRENT_VERSION"
echo -e "\t[ INFO ] Version final: $NEW_VERSION"

OUTPUT=`$DOCKER_DAEMON build -t $APP_NAME:$NEW_VERSION .`

if [[ $OUTPUT =~ "Successfully" ]]; then
	echo -e "[ OK ] Image creada correctamente..."

	echo -e "\n[ INFO ] Generando contenedor..."

	$DOCKER_DAEMON rm -f $APP_NAME > /dev/null 2>&1
 	CONTAINER_ID=$($DOCKER_DAEMON run -d -p $LOCAL_PORT:$REMOTE_PORT --name $APP_NAME $APP_NAME:$NEW_VERSION)
	echo -e "\t[ INFO ] ID Contenedor $CONTAINER_ID"
	echo -e "\t[ INFO ] Contenedor ejecutandose en: http://localhost:$LOCAL_PORT"
fi
