WITH CarStats AS (SELECT c.name,
                         c.class,
                         AVG(r.position) AS avg_position,
                         COUNT(*)        AS num_races
                  FROM Cars c
                           JOIN Results r ON c.name = r.car
                  GROUP BY c.name, c.class),
     MinAvg AS (SELECT class,
                       MIN(avg_position) AS min_avg
                FROM CarStats
                GROUP BY class)

SELECT cs.name         as car_name,
       cs.class        as car_class,
       cs.avg_position as average_position,
       cs.num_races    as race_count
FROM CarStats cs
         JOIN MinAvg m ON cs.class = m.class AND cs.avg_position = m.min_avg
ORDER BY cs.avg_position;
