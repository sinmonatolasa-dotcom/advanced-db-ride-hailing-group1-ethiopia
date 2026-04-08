# Task 3: Transactions & Concurrency Control

**Problem:**  
Two riders can book the same driver at the same time (double-booking / lost update).

**Solution using Serializable Isolation Level:**
```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;

-- Lock the driver row to prevent double-booking
SELECT status FROM drivers WHERE driver_id = 1 FOR UPDATE;

UPDATE drivers SET status = 'busy' WHERE driver_id = 1;

INSERT INTO rides (rider_id, driver_id, pickup_location, dropoff_location, base_fare_etb)
VALUES (1, 1, ST_MakePoint(38.74, 9.03), ST_MakePoint(38.80, 9.05), 150.00);

COMMIT;
