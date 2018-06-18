#! /usr/bin/env bash

dnf -y update
dnf -y install dnf-plugins-core git wget vim unzip

dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y config-manager --set-enabled docker-ce-edge
dnf -y update
dnf -y install docker-ce docker-compose

systemctl enable docker && systemctl start docker
timedatectl set-timezone America/Sao_Paulo

mkdir -p \
    /opt/zup/config \
    /opt/zup/postgres-data \
    /opt/zup/uploads \
    /opt/zup/shared_images \
    /opt/zup/logs/api \
    /opt/zup/shapefiles \
    /opt/zup/logs/nginx

if [ ! -d "zup-web" ]; then
    # quando for instalar fazer clone do seu próprio repositório
    git clone https://github.com/AlipioNeto/zup-web
else
    cd zup-web && git pull && cd ..
fi
if [ ! -d "zup-api" ]; then
    # quando for instalar fazer clone do seu próprio repositório
    git clone https://github.com/AlipioNeto/zup-api
else
    cd zup-api && git pull && cd ..
fi

# configuração para o container zup-web
echo -e "API_URL=http://167.99.40.116/api
MAP_LAT=-23.5422051
MAP_LNG=-46.6354627
MAP_ZOOM=11
DISABLE_LANDING_PAGE=false
DISABLE_WEB_APP=false
PAGE_TITLE=Sistema ZUP
DEFAULT_CITY=São Paulo
DEFAULT_STATE=SP
DEFAULT_COUNTRY=Brasil
GOOGLE_API_KEY=AIzaSyCZ-gCb7UvwXp3PzwGKwTuB3FsCU-5i47E" > /opt/zup/config/web.env

# configuração para o container zup-api
echo -e "API_DOMAIN=http://167.99.40.116/api
API_URL=http://167.99.40.116/api
ASSET_HOST_URL=http://167.99.40.116/api
WEB_URL=http://167.99.40.116/painel
SMTP_ADDRESS=mail.lliege.com.br
RACK_ENV=production
SMTP_PORT=465
SMTP_USER=zup@lliege.com.br
SMTP_PASS=lliege123
SMTP_TTLS=true
SMTP_AUTH=plain
MAIL_HEADER_IMAGE=/usr/src/app/public/shared_images/header.jpg
REDIS_URL=redis://redis:6379

# your database information here. change if necessary
# ex.: DATABASE_URL=postgis://YOUR-DB-USER:YOUR-DB-PASSWORD@postgres:5432/zup_db
DATABASE_URL=postgis://db_user:9753159@postgres:5432/zup_db

SIDEKIQ_USER=admin
SIDEKIQ_PASSWORD=123456

# optional settings
RAILS_TIMEZONE=America/Sao_Paulo
TZ=America/Sao_Paulo
SENDER_EMAIL=zup@lliege.com.br
SENDER_NAME=zup
SERVER_WORKERS=2

LIMIT_CITY_BOUNDARIES=true
GEOCODM=3550308" > /opt/zup/config/api.env

# configuração para o postgresql
echo -e "POSTGRES_USER=db_user
POSTGRES_PASSWORD=9753159
POSTGRES_DB=zup_db" > /opt/zup/config/postgres.env
