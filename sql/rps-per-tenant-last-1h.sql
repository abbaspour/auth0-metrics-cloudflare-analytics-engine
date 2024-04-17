SELECT toStartOfInterval(timestamp, INTERVAL '1' SECOND ) AS ts,
       index1 as tenant,
       sum(_sample_interval) as rps
FROM RATE_LIMIT
WHERE timestamp > NOW() - INTERVAL '1' HOUR
Group by tenant, ts
order by ts
