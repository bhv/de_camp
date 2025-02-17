#!/bin/bash

docker run -it \
-e POSTGRES_USER="sagar" \
-e POSTGRES_PASSWORD="sagar" \
-e POSTGRES_DB="ny_taxi" \
-v /Users/sagarbhavsar/MyRepo/de_camp/module_1/2_docker_postgres/ny_taxi_postgres_data:/var/lib/postgresql/data \
-p 5432:5432 \
postgres:13
