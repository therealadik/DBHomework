SELECT v.maker, v.model
FROM vehicle AS v
         JOIN motorcycle AS m ON m.model = v.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
  AND v.type = 'Motorcycle'
ORDER BY m.horsepower DESC;