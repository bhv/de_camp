-- generating model for source('staging', 'fhv_trip_data_external')...
{{
    config(
        materialized='view'
    )
}}

with fhv_data as (
    select *
    from {{ source('staging', 'fhv_trip_data_external') }}
    where dispatching_base_num is not null
)

select * from fhv_data