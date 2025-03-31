WITH hotel_cat AS (SELECT h.ID_hotel,
                          h.name  AS hotel_name,
                          CASE
                              WHEN AVG(r.price) < 175 THEN 'Дешевый'
                              WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
                              ELSE 'Дорогой'
                              END AS hotel_type
                   FROM Hotel h
                            JOIN Room r ON h.ID_hotel = r.ID_hotel
                   GROUP BY h.ID_hotel, h.name),
     customer_preferences AS (SELECT c.ID_customer,
                                     c.name,
                                     -- Определяем максимальный приоритет категории отелей, посещённых клиентом:
                                     MAX(
                                             CASE
                                                 WHEN hc.hotel_type = 'Дорогой' THEN 3
                                                 WHEN hc.hotel_type = 'Средний' THEN 2
                                                 WHEN hc.hotel_type = 'Дешевый' THEN 1
                                                 END
                                     )                                                              AS max_type_value,
                                     -- Собираем список уникальных отелей, посещённых клиентом:
                                     STRING_AGG(DISTINCT hc.hotel_name, ',' ORDER BY hc.hotel_name) AS visited_hotels
                              FROM Customer c
                                       JOIN Booking b ON c.ID_customer = b.ID_customer
                                       JOIN Room r ON b.ID_room = r.ID_room
                                       JOIN hotel_cat hc ON r.ID_hotel = hc.ID_hotel
                              GROUP BY c.ID_customer, c.name)
SELECT ID_customer,
       name,
       CASE
           WHEN max_type_value = 3 THEN 'Дорогой'
           WHEN max_type_value = 2 THEN 'Средний'
           ELSE 'Дешевый'
           END AS preferred_hotel_type,
       visited_hotels
FROM customer_preferences
ORDER BY max_type_value, -- сначала клиенты с max_type_value = 1 (Дешевый), затем 2 и 3
         ID_customer;
