if docker ps -a | grep observium-mysql
then
  if docker ps | grep observium-mysql
  then
    echo 'observium-mysql container already running...'
    echo 'Skip starting observium-mysql'
  else
    MYSQL_CID=$(docker ps -a | grep observium-mysql | awk '{ print $1 }')
    docker start $MYSQL_CID
  fi
else
  echo 'No previous observium-mysql container found'
  echo 'Starting fresh observium-mysql'
  docker run --name observium-mysql -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -d hypriot/rpi-mysql:5.5
fi
sleep 1

docker run -d \
    --name observium \
    --link observium-mysql \
    -p 8000:8000 \
    -v /mnt/data/observium/volumes/config:/config \
    -v /mnt/data/observium/volumes/html:/opt/observium/html \
    -v /mnt/data/observium/volumes/logs:/opt/observium/logs \
    -v /mnt/data/observium/volumes/rrd:/opt/observium/rrd \
    trinitronx/observium

