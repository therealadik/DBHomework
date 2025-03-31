WITH
-- Подсчёт статистики по каждому автомобилю: средняя позиция и количество гонок
CarStats AS (SELECT c.name,
                    c.class,
                    AVG(r.position) AS avg_position,
                    COUNT(*)        AS num_races
             FROM Cars c
                      JOIN Results r ON c.name = r.car
             GROUP BY c.name, c.class),

-- Подсчёт статистики по классу: общая средняя позиция (по всем результатам) и количество автомобилей в классе
ClassStats AS (SELECT c.class,
                      AVG(r.position)        AS class_avg,
                      COUNT(DISTINCT c.name) AS car_count
               FROM Cars c
                        JOIN Results r ON c.name = r.car
               GROUP BY c.class)

SELECT cs.name         as car_name,
       cs.class        as car_class,
       cs.avg_position as average_position,
       cs.num_races    as race_count,
       cl.country      as car_country
FROM CarStats cs
         JOIN ClassStats cstats ON cs.class = cstats.class
         JOIN Classes cl ON cs.class = cl.class
WHERE cstats.car_count >= 2              -- выбираем только классы, где минимум два автомобиля
  AND cs.avg_position < cstats.class_avg -- автомобиль с лучшей (меньшей) средней позицией, чем средняя по классу
ORDER BY cs.class, cs.avg_position;
