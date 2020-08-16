#!/bin/sh

# container
if [ "$1" = "container" ]; then
  if [ "$2" = "remove" ]; then
    if [ "$3" = "all" ]; then
      docker ps -aq
      docker stop $(docker ps -aq)
      docker rm $(docker ps -aq)
    fi
  fi

  if [ "$2" = "create" ]; then
    port="$3"
    name="$4"
    image_name="$5"
    source=$PWD/app
    docker run -d -v $source:/var/www/html -p $port:80 --name $name $image_name
  fi

  if [ "$2" = "run" ]; then
    name="$3"
    docker start $name
  fi

  if [ "$2" = "stop" ]; then
    name="$3"
    docker stop $name
  fi

  if [ "$2" = "login" ]; then
    container="$3"
    docker exec -it $container /bin/bash
  fi
fi

# images

if [ "$1" = "image" ]; then
  if [ "$2" = "remove" ]; then
    images=$(docker images -q)
    docker image ls
    docker rmi $images -f
  fi

  if [ "$2" = 'build' ]; then
    name="$3"
    docker build -t $name .
  fi

fi
