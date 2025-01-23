#!/bin/bash

docker pull dpage/pgadmin4

docker run -it \
-e PGADMIN_DEFAULT_EMAIL="sagar@sagar.com" \
-e PGADMIN_DEFAULT_PASSWORD="sagar" \
-p 8080:80 \
--network=pg-network \
--name pgadmin \
dpage/pgadmin4

