cls

$VERSION="1.0.0"
$WORKDIR=(Get-Location).Path

echo "[ INFO ] SCRIPT VERSION: $VERSION\n"
echo "`t[ INFO ] WORKDIR: $WORKDIR"
echo "`t[ INFO ] DOCKER_DAEMON: $DOCKER_DAEMON"

echo "`n[ INFO ] Buscando contenedores"
$CONTAINERS=$(docker ps -aq)

foreach ($container in $CONTAINERS) {
    echo "`t[ INFO ] Eliminando contenedor ID $container"
    docker rm -f $container | out-null
}

echo "[ INFO ] Eliminando imagenes..."

$IMAGES=$(docker image ls -aq)

foreach ($image in $IMAGES) {
    echo "`t[ INFO ] Eliminando imagen ID $image"
    docker image rm -f $image | out-null
}