with 

source as (

    select * from {{ source('cc', 'parcel') }}

),

renamed as (

    select
        Parcel_id as parcel_id,
        Parcel_tracking as parcel_tracking,
        Transporter as transporter,
        Priority as priority,
        PARSE_DATE('%b %d, %Y', Date_purCHase) as date_purchase,
        PARSE_DATE('%b %d, %Y', Date_sHIpping) as date_shipping,
        PARSE_DATE('%b %d, %Y', DATE_delivery) as date_delivery,
        PARSE_DATE('%b %d, %Y', DaTeCANcelled) as date_cancelled
    from source

)

select * from renamed