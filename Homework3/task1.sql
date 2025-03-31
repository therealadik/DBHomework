SELECT c.name,
       c.email,
       c.phone,
       COUNT(b.ID_booking)                               AS total_bookings,
       STRING_AGG(DISTINCT h.name, ', ' ORDER BY h.name) AS hotels,
       AVG(b.check_out_date - b.check_in_date)           AS avg_stay_duration
FROM Customer c
         JOIN Booking b ON c.ID_customer = b.ID_customer
         JOIN Room r ON b.ID_room = r.ID_room
         JOIN Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY c.name, c.email, c.phone
HAVING COUNT(b.ID_booking) > 2
   AND COUNT(DISTINCT h.ID_hotel) > 1
ORDER BY total_bookings DESC;
