### 7. security.sql

```sql
-- Task 4: Security & RBAC
CREATE ROLE app_rider;
CREATE ROLE app_admin;

GRANT SELECT, INSERT ON rides, payments TO app_rider;
GRANT ALL ON ALL TABLES IN SCHEMA public TO app_admin;

-- Encryption example
UPDATE users SET phone = pgp_pub_encrypt('251911111111'::bytea, 'public_key');
