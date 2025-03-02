{{
    config(
        materialized='view'
    )
}}


with filtered_fact_trip as (
    select *
    from {{ ref('fact_trips') }}
    where fare_amount > 0 
        and trip_distance > 0
        and lower(payment_type_description) in ('cash', 'credit card')
    order by service_type, year, month
)

select 
    distinct service_type,
    year,
    month,
    percentile_cont(fare_amount, 0.90) over (partition by service_type, year, month) as p_90,
    percentile_cont(fare_amount, 0.95) over (partition by service_type, year, month) as p_95,
    percentile_cont(fare_amount, 0.97) over (partition by service_type, year, month) as p_97
from filtered_fact_trip