

-- taxi-data-449119
-- gs://taxi-data-449119/yellow_tripdata_2024-01.parquet

--external table
CREATE OR REPLACE EXTERNAL TABLE de-camp-449119.ny_taxi.external_yellow_taxi_data
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://taxi-data-449119/yellow_tripdata_2024-*.parquet']

);

select * from `ny_taxi.external_yellow_taxi_data` limit 10;

-- materialized table
CREATE OR REPLACE TABLE de-camp-449119.ny_taxi.yellow_taxi_data as
select * from `ny_taxi.external_yellow_taxi_data`;


-- distinct number of PULocationIDs
select count(distinct PULocationID) from de-camp-449119.ny_taxi.external_yellow_taxi_data;

select count(distinct PULocationID) from de-camp-449119.ny_taxi.yellow_taxi_data;


-- Retrive PULocationID and DOLocationID
select PULocationID from de-camp-449119.ny_taxi.yellow_taxi_data;
select PULocationID, DOLocationID from de-camp-449119.ny_taxi.yellow_taxi_data;

-- Zero fair amount
select count(*) from de-camp-449119.ny_taxi.yellow_taxi_data
where fare_amount = 0;




-- retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive) from non-partitioned
select distinct VendorID from de-camp-449119.ny_taxi.yellow_taxi_data
where DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive) from partitioned & clustered
CREATE OR REPLACE TABLE de-camp-449119.ny_taxi.yellow_taxi_data_partitioned
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM de-camp-449119.ny_taxi.yellow_taxi_data;

select distinct VendorID from de-camp-449119.ny_taxi.yellow_taxi_data_partitioned
where DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';


-- Is it best practice in Big Query to always cluster your data?:
-- No, if table is small, no frequently queried and clustered on a column with low distinct values is not worth the cost and can degrade query performance.



-- Estimated MBs processed
select count(*) from de-camp-449119.ny_taxi.yellow_taxi_data;

-- It will process 0 MBs since total_rows will be fetched from metadata by Bigquery.



