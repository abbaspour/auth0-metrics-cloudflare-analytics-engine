select blob1                                                   AS path,
       SUM(_sample_interval * double3) / SUM(_sample_interval) as avg_latency
from RATE_LIMIT
where index1 = 'cf-ae-metrics.au.auth0.com'
    AND timestamp > NOW() - INTERVAL '1' DAY
group by path
