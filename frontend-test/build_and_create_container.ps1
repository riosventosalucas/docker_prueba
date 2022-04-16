#!/bin/bash

clear

$VERSION="1.0.0"
$APP_NAME="frontendapp"
$WORKDIR=(Get-Location).Path
$CURRENT_VERSION=0
$LOCAL_PORT=8000
$REMOTE_PORT=80

echo "[ INFO ] SCRIPT VERSION: $VERSION`n"
echo "`t[ INFO ] APPNAME: $APP_NAME"
echo "`t[ INFO ] WORKDIR: $WORKDIR"

echo "`n[ INFO ] Buscando versiones anteriores..."

ALREADY_EXIST=$(docker image ls | grep $APP_NAME)

if [[ -z $ALREADY_EXIST ]]; then
    echo "`t[ NOTICE ] Ninguna version anterior encontrada"
    echo "`t[ INFO ] Configurando version en 1."
    $CURRENT_VERSION=1
    $NEW_VERSION=$CURRENT_VERSION
    echo "FROM nginx:alpine

COPY dist/ /usr/share/nginx/html" > $WORKDIR/Dockerfile

else
    $CURRENT_VERSION=$$(docker image ls | Select-String -Pattern 'ubuntu' | Out-String -Stream).replace("`n", "").replace(" ",",").replace(",,,", ",").replace(",,,",",").replace(",,", ",").split(",")[2]
    $NEW_VERSION=$((CURRENT_VERSION+1))
    sed -i "s/nginx\:alpine/$APP_NAME:$CURRENT_VERSION/g" $WORKDIR/Dockerfile
fi


echo "`n[ INFO ] Creando imagen..."
echo "`t[ INFO ] Version actual: $CURRENT_VERSION"
echo "`t[ INFO ] Version final: $NEW_VERSION"

OUTPUT=`$DOCKER_DAEMON build -t $APP_NAME:$NEW_VERSION .`

if [[ $OUTPUT =~ "Successfully" ]]; then
    echo "[ OK ] Image creada correctamente..."

    echo "`n[ INFO ] Generando contenedor..."

    $DOCKER_DAEMON rm -f $APP_NAME > /dev/null 2>&1
    CONTAINER_ID=$($DOCKER_DAEMON run -d -p $LOCAL_PORT:$REMOTE_PORT --name $APP_NAME $APP_NAME:$NEW_VERSION)
    echo "`t[ INFO ] ID Contenedor $CONTAINER_ID"
    echo "`t[ INFO ] Contenedor ejecutandose en: http://localhost:$LOCAL_PORT"
fi
