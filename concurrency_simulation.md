# Task 3: Transactions & Concurrency

**Problem:** Two riders can book the same driver at the same time (double booking).

**Solution (Pessimistic Locking):**
```sql
BEGIN;
SELECT status FROM drivers WHERE driver_id = 1 FOR UPDATE;  -- Lock the row
-- Check available then
UPDATE drivers SET status = 'busy' WHERE driver_id = 1;
INSERT INTO rides (...) VALUES (...);
COMMIT;
