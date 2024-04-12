SELECT blob1 AS tenant,
       double1 as limit,
       double2 as remaining,
       _sample_interval
FROM RATE_LIMIT
         LIMIT 10