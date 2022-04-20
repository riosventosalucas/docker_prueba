#! /usr/bin/pwsh

cls

$VERSION="1.0.0"
$APP_NAME="backendapp"
$WORKDIR=$(pwd)
$DOCKER_DAEMON='docker'
$CURRENT_VERSION=0
$NEW_VERSION=0
$LOCAL_PORT=8001
$REMOTE_PORT=80

Write-host "[ INFO ] SCRIPT VERSION: $VERSION`n"
Write-host "`t[ INFO ] APPNAME: $APP_NAME"
Write-host "`t[ INFO ] WORKDIR: $WORKDIR"
Write-host "`t[ INFO ] DOCKER_DAEMON: $DOCKER_DAEMON"

Write-host "`n[ INFO ] Buscando versiones anteriores..."

$ALREADY_EXIST=$(docker image ls | grep $APP_NAME | ForEach-Object { $_.split(" ")[0] })

if ( -not $ALREADY_EXIST) {
    Write-host "`t[ NOTICE ] Ninguna version anterior encontrada"
    Write-host "`t[ INFO ] Configurando version en 1."
    $CURRENT_VERSION=1
    $NEW_VERSION=$CURRENT_VERSION
    Write-output "FROM python:alpine`nCOPY dist/ /usr/src/`nWORKDIR /usr/src`nRUN python3 -m venv env`n RUN source env/bin/activate`nRUN pip3 install -r requirements.txt" | Out-file -encoding utf8 $WORKDIR/Dockerfile
}
else {
    $CURRENT_VERSION=$(docker image ls | grep $APP_NAME | ForEach-Object { $_.split(" ")[3] })
    $NEW_VERSION=[int]$([int]$CURRENT_VERSION + 1)
    (Get-Content -path $WORKDIR/Dockerfile).replace("nginx:alpine", "${APP_NAME}:${CURRENT_VERSION}") | Set-Content $WORKDIR/Dockerfile
}
Write-host "`n[ INFO ] Creando imagen..."
Write-host "`t[ INFO ] Version actual: $CURRENT_VERSION"
Write-host "`t[ INFO ] Version final: $NEW_VERSION"

$OUTPUT=$(docker build -t ${APP_NAME}:${NEW_VERSION} .)


if ($OUTPUT -like "*naming*") {
    Write-host "[ OK ] Image creada correctamente..."

    Write-host "`n[ INFO ] Generando contenedor..."
    docker rm -f $APP_NAME
    
    $CONTAINER_ID=$(docker run -d -p ${LOCAL_PORT}:${REMOTE_PORT} --name $APP_NAME ${APP_NAME}:${NEW_VERSION} python3 /usr/src/app.py)
    Write-host "`t[ INFO ] ID Contenedor $CONTAINER_ID"
    Write-host "`t[ INFO ] Contenedor ejecutandose en: http://localhost:$LOCAL_PORT"
}

