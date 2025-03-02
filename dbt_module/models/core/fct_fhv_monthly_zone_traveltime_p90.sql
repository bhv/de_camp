{{
    config(
        materialized='view'
    )
}}

with dim_fhv_trips_timediff as (
    select *,
    timestamp_diff(dropoff_datetime, pickup_datetime,  MINUTE) as trip_duration
    from {{ ref('dim_fhv_trips') }}
)

select 
    dropoff_zone,
    pickup_zone,
    year,
    month,
    percentile_cont(trip_duration, 0.9) over (partition by year, month, pulocationid, dolocationid) as p_90
from 
dim_fhv_trips_timediff
