WITH
-- Вычисляем статистику по каждому автомобилю: средняя позиция и число гонок
CarStats AS (SELECT c.name,
                    c.class,
                    AVG(r.position) AS avg_position,
                    COUNT(*)        AS num_races
             FROM Cars c
                      JOIN Results r ON c.name = r.car
             GROUP BY c.name, c.class),

-- Вычисляем статистику по классам: средняя позиция по всем автомобилям класса и общее число гонок
ClassStats AS (SELECT c.class,
                      AVG(r.position) AS class_avg,
                      COUNT(*)        AS total_races
               FROM Cars c
                        JOIN Results r ON c.name = r.car
               GROUP BY c.class),

-- Определяем минимальное значение средней позиции среди классов
MinAvg AS (SELECT MIN(class_avg) AS min_class_avg
           FROM ClassStats),

-- Выбираем классы, у которых средняя позиция равна минимальной
SelectedClasses AS (SELECT cs.class, cs.total_races
                    FROM ClassStats cs
                             JOIN MinAvg ma ON cs.class_avg = ma.min_class_avg)

-- Выводим информацию по каждому автомобилю из выбранных классов
SELECT cs.name         as car_name,
       cs.class        as car_class,
       cs.avg_position as average_position,
       cs.num_races    as race_count,
       cl.country      as car_country,
       sc.total_races  as total_races
FROM CarStats cs
         JOIN SelectedClasses sc ON cs.class = sc.class
         JOIN Classes cl ON cs.class = cl.class
ORDER BY cs.name;
