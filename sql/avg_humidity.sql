SELECT
    blob1 AS city,
    SUM(_sample_interval * double2) / SUM(_sample_interval) AS avg_humidity
FROM WEATHER
WHERE double1 > 0
GROUP BY city
ORDER BY avg_humidity DESC
    LIMIT 10