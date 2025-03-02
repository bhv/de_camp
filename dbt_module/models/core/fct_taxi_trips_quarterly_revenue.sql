{{
    config(
        materialized='view'
    )
}}

with ordered_fact_trip as (
    select *
    from {{ ref('fact_trips') }}
    order by service_type, pickup_datetime
),

total_amount as (
    select service_type, year, quarter, year_quarter,
    sum(total_amount) as total_amt
    from ordered_fact_trip
    group by service_type, year, quarter, year_quarter
    order by service_type, quarter, year
),

total_amt_with_prev_quarter as (
    select service_type, year, quarter, year_quarter,
    total_amt,
    LAG(total_amt) over (partition by service_type, quarter order by year) as prev_amt
    from total_amount
)


select *,
ROUND(((total_amt - prev_amt) * 100) / NULLIF(prev_amt, 0),2) quarterly_change
from total_amt_with_prev_quarter
order by service_type, quarter, year;

-- select
-- service_type, year_quarter,
-- ROUND(((total_amt - prev_amt) * 100) / NULLIF(prev_amt, 0),2) quarterly_change

-- from total_amt_with_prev_quarter
-- order by service_type, year, quarter