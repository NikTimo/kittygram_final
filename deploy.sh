#!/bin/bash
PS3='All choises requeres SuperUSer password for Server SuperUSer. Please enter your choice: '
options=("Dowload latest images from DockerHub" "Build from local files" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Dowload latest images from DockerHub")
            sudo -S docker compose -f docker-compose.production.yml pull
            sudo docker compose -f docker-compose.production.yml down
            sudo docker compose -f ./docker-compose.production.yml up -d
            sudo docker compose -f docker-compose.production.yml exec backend python manage.py migrate
            sudo docker compose -f docker-compose.production.yml exec backend python manage.py collectstatic
            sudo docker compose -f docker-compose.production.yml exec backend cp -r /app/collected_static/. /backend_static/static/
            echo "Creating SuperUSer for Django"
            sudo docker compose -f docker-compose.production.yml exec backend python manage.py createsuperuser
            break
            ;;
        "Build from local files")
            sudo -S docker compose -f docker-compose.yml pull
            sudo docker compose -f docker-compose.yml down
            sudo docker compose -f ./docker-compose.yml up -d
            sudo docker compose -f docker-compose.yml exec backend python manage.py migrate
            sudo docker compose -f docker-compose.yml exec backend python manage.py collectstatic
            sudo docker compose -f docker-compose.yml exec backend cp -r /app/collected_static/. /backend_static/static/
            echo "Creating SuperUSer for Django"
            sudo docker compose -f docker-compose.yml exec backend python manage.py createsuperuser
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done