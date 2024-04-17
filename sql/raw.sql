SELECT timestamp,
       blob1 AS path,
       double1 as limit,
       double2 as remaining,
       double3 as latency,
       double4 as status,
       index1 as tenant,
       _sample_interval
FROM RATE_LIMIT
    WHERE tenant = 'cf-ae-metrics.au.auth0.com'
    order by timestamp desc
         LIMIT 10