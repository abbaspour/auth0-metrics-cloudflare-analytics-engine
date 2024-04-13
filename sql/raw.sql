SELECT blob1 AS path,
       double1 as limit,
       double2 as remaining,
       double3 as latency,
       index1 as tenant,
       _sample_interval
FROM RATE_LIMIT
    WHERE tenant = 'cf-ae-metrics.au.auth0.com'
         LIMIT 10