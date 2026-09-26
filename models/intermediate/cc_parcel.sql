WITH agg_parcel_product as (
    SELECT
        parcel_id
        , count(*) as nb_model
        , sum(quantity) as qty
    FROM {{ ref("stg_cc__parcel_product")}}
    GRoup by parcel_id
)

SELECT
    p.*
    , EXTRACT(MONTH FROM date_purchase) as month_purchase
    , CASE
        WHEN date_cancelled is not null THEN "Cancelled"
        WHEN date_delivery is not null THEN "Delivered"
        WHEN date_shipping is not null THEN "Shipped"
        WHEN date_purchase is not null THEN "In Porgress"
        ELSE null
      END as status
    , DATE_DIFF(date_shipping, date_purchase, DAY) as expedition_time
    , DATE_DIFF(date_delivery, date_shipping, DAY) as transport_time
    , DATE_DIFF(date_delivery, date_purchase, DAY) as delivery_time
    , IF(DATE_DIFF(date_delivery, date_purchase, DAY) > 5,  (DATE_DIFF(date_delivery, date_purchase, DAY) - 5), null) as delay
    , qty
    , nb_model
FROM {{ ref("stg_cc__parcel" )}} as p
JOIN agg_parcel_product
    using(parcel_id)