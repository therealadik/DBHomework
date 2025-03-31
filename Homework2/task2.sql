WITH CarStats AS (SELECT c.name,
                         c.class,
                         AVG(r.position) AS avg_position,
                         COUNT(*)        AS num_races
                  FROM Cars c
                           JOIN Results r ON c.name = r.car
                  GROUP BY c.name, c.class)
SELECT cs.name         as car_name,
       cs.class        as car_class,
       cs.avg_position as average_position,
       cs.num_races    as race_count,
       cl.country      as car_country
FROM CarStats cs
         JOIN Classes cl ON cs.class = cl.class
ORDER BY cs.avg_position, cs.name
LIMIT 1;
