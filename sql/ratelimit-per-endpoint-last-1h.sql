SELECT toStartOfInterval(timestamp, INTERVAL '1' SECOND ) AS ts,
       index1 as tenant,
       blob1 AS path,
       max(double1) as limit,
       min(double2) as remaining
FROM RATE_LIMIT
WHERE timestamp > NOW() - INTERVAL '1' HOUR
Group by tenant, path, ts
order by ts
