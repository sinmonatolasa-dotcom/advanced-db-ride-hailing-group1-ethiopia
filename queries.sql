-- Task 2: Optimized Queries

-- 1. Find nearest available drivers (uses GIST index)
SELECT 
    d.driver_id, 
    d.full_name, 
    d.vehicle_model,
    ST_Distance(d.current_location, ST_MakePoint(38.74, 9.03)::geography) AS distance_meters
FROM drivers d
WHERE d.status = 'available'
  AND ST_DWithin(d.current_location, ST_MakePoint(38.74, 9.03)::geography, 15000)
ORDER BY d.current_location <-> ST_MakePoint(38.74, 9.03)::geography
LIMIT 5;

-- 2. Calculate surge pricing zones
WITH demand AS (
    SELECT 
        c.name AS city,
        COUNT(CASE WHEN r.status IN ('requested','accepted','in_progress') THEN 1 END) AS active_rides,
        COUNT(CASE WHEN d.status = 'available' THEN 1 END) AS available_drivers
    FROM cities c
    LEFT JOIN drivers d ON d.city_id = c.city_id
    LEFT JOIN rides r ON r.driver_id = d.driver_id AND r.status != 'completed'
    GROUP BY c.name
)
SELECT 
    city,
    CASE 
        WHEN available_drivers = 0 THEN 2.5
        WHEN active_rides::float / NULLIF(available_drivers, 0) > 1.5 THEN 1.8
        ELSE 1.0 
    END AS surge_multiplier
FROM demand;

-- 3. Daily revenue report
SELECT 
    DATE(completed_at) AS report_date,
    COUNT(*) AS total_rides,
    SUM(total_fare_etb) AS total_revenue_etb,
    AVG(surge_multiplier) AS avg_surge
FROM rides
WHERE status = 'completed'
GROUP BY DATE(completed_at)
ORDER BY report_date DESC;
