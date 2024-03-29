#!/usr/bin/env bash
if [ "$2" == "clone" ]; then
  git clone https://github.com/charlesalmeida/Magento1.git $1 && cd $1;
fi

sudo chmod u+x ./*

if [ "$(uname)" == "Darwin" ] || [ "$(uname)" == "cygwin" ] || [ "$(uname)" == "msys" ] || [ "$(uname)" == "win32" ]; then
  git checkout -f mac;
  sed -i '' -e "s/<project_name>/$1/g" docker-compose.yml \
  && sed -i '' -e "s/<project_name>/$1/g" docker-compose-dev.yml \
  && sed -i '' -e "s/<project_name>/$1/g" docker-sync.yml
else
  git checkout -f master;
  sed -i '' -e "s/<project_name>/$1/g" docker-compose.yml;
fi

if [ ! -e src/index.php ]; then
  echo "<?php phpinfo();" > src/index.php;
fi

if [ -d src/app/etc ]; then
  if [ ! -e src/app/etc/local.xml ]; then
    cp -rv .docker/users/local.xml.sample src/app/etc/local.xml;
  fi
fi

bash start
