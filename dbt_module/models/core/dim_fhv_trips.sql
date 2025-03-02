{{
    config(
        materialized='view'
    )
}}

with filtered_fhv as (
    select *
    from {{ ref('stg_fhv_tripdata') }}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)

select 
    filtered_fhv.*,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
EXTRACT(YEAR FROM filtered_fhv.pickup_datetime) as year,
    EXTRACT(QUARTER FROM filtered_fhv.pickup_datetime) as quarter,
    EXTRACT(MONTH FROM filtered_fhv.pickup_datetime) as month,
from filtered_fhv
inner join dim_zones as pickup_zone
on filtered_fhv.pulocationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on filtered_fhv.dolocationid = dropoff_zone.locationid
