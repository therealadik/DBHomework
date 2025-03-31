select v.maker,
       v.model,
       c.horsepower,
       c.engine_capacity,
       'Car' as vehicle_type
from vehicle as v
         join car c on v.model = c.model
where c.horsepower > 150
  and c.engine_capacity < 3
  and price < 35000

union all

select v.maker,
       v.model,
       m.horsepower,
       m.engine_capacity,
       'Motorcycle' as vehicle_type
from vehicle as v
         join motorcycle m on m.model = v.model
where m.horsepower > 150
  and m.engine_capacity < 1.5
  and m.price < 20000

union all

SELECT v.maker,
       v.model,
       NULL      AS horsepower,
       NULL      AS engine_capacity,
       'Bicycle' AS vehicle_type
FROM Vehicle v
         JOIN Bicycle b ON v.model = b.model
WHERE b.gear_count > 18
  AND b.price < 4000
  AND v.type = 'Bicycle'

ORDER BY horsepower DESC NULLS LAST;