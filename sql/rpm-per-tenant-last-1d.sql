SELECT toStartOfInterval(timestamp, INTERVAL '1' MINUTE) AS minute,
       index1 as tenant,
       sum(_sample_interval) as rpm
FROM RATE_LIMIT
WHERE timestamp > NOW() - INTERVAL '1' DAY
Group by tenant, minute
order by minute
