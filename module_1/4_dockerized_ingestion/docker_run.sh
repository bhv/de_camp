#!/bin/bash

docker build -t csv_ingestion:0.0.9 .

docker run -it \
    -e DB_USER="sagar" \
    -e DB_PASSWORD="sagar" \
    -e DB_HOST="pg-database" \
    -e DB_PORT="5432" \
    -e DB_NAME="ny_taxi" \
    -e TABLE_NAME="yellow_taxi_data_v2" \
    -e DATA_FILE_PATH="./csv_data_files/yellow_tripdata_2021-01.csv" \
--network=pg-network \
csv_ingestion:0.0.9