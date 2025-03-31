WITH CarStats AS (SELECT c.name          AS car_name,
                         c.class         AS car_class,
                         AVG(r.position) AS average_position,
                         COUNT(*)        AS race_count
                  FROM Cars c
                           JOIN Results r ON c.name = r.car
                  GROUP BY c.name, c.class),
     ClassStats AS (SELECT cs.car_class,
                           SUM(cs.race_count)                                     AS total_races,
                           COUNT(CASE WHEN cs.average_position >= 3.0 THEN 1 END) AS low_position_count
                    FROM CarStats cs
                    GROUP BY cs.car_class)
SELECT cs.car_name,
       cs.car_class,
       cs.average_position,
       cs.race_count,
       cl.country AS car_country,
       clstats.total_races,
       clstats.low_position_count
FROM CarStats cs
         JOIN Classes cl ON cs.car_class = cl.class
         JOIN ClassStats clstats ON cs.car_class = clstats.car_class
WHERE cs.average_position > 3.0
ORDER BY clstats.low_position_count DESC;
