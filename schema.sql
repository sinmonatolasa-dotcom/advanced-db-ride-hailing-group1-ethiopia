---

### 3. schema.sql

```sql
-- Task 1: Advanced Schema Design (Normalized + Indexing Strategy)
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Cities Table
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Users (Riders)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city_id INTEGER REFERENCES cities(city_id),
    phone BYTEA NOT NULL,                    -- Encrypted
    email VARCHAR(100) UNIQUE,
    rating DECIMAL(3,2) DEFAULT 5.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Drivers
CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    vehicle_model VARCHAR(50) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    city_id INTEGER REFERENCES cities(city_id),
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available','busy','offline')),
    current_location GEOGRAPHY(POINT, 4326),
    rating DECIMAL(3,2) DEFAULT 5.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Driver Location History (for real-time tracking)
CREATE TABLE driver_location_history (
    history_id SERIAL PRIMARY KEY,
    driver_id INTEGER REFERENCES drivers(driver_id) ON DELETE CASCADE,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Rides (Core Table - ACID critical)
CREATE TABLE rides (
    ride_id SERIAL PRIMARY KEY,
    rider_id INTEGER REFERENCES users(user_id),
    driver_id INTEGER REFERENCES drivers(driver_id),
    pickup_location GEOGRAPHY(POINT, 4326) NOT NULL,
    dropoff_location GEOGRAPHY(POINT, 4326) NOT NULL,
    status VARCHAR(20) DEFAULT 'requested',
    base_fare_etb DECIMAL(10,2) NOT NULL,
    surge_multiplier DECIMAL(3,2) DEFAULT 1.00,
    total_fare_etb DECIMAL(10,2) GENERATED ALWAYS AS (base_fare_etb * surge_multiplier) STORED,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accepted_at TIMESTAMP,
    completed_at TIMESTAMP,
    estimated_duration_min INTEGER
);

-- Payments
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    ride_id INTEGER REFERENCES rides(ride_id) ON DELETE CASCADE,
    amount_etb DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    encrypted_details BYTEA,
    paid_at TIMESTAMP
);

-- Audit Logs (Security & Fraud Prevention)
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    performed_by INTEGER,
    action_type VARCHAR(50),
    table_name VARCHAR(50),
    record_id INTEGER,
    old_data JSONB,
    new_data JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ratings
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    ride_id INTEGER REFERENCES rides(ride_id),
    driver_id INTEGER REFERENCES drivers(driver_id),
    score DECIMAL(3,2) CHECK (score BETWEEN 1 AND 5),
    comment TEXT,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==================== INDEXING STRATEGY ====================
CREATE INDEX idx_drivers_status_city ON drivers (status, city_id);
CREATE INDEX idx_drivers_location_gist ON drivers USING GIST (current_location);   -- Critical for nearest driver query
CREATE INDEX idx_rides_status_driver ON rides (status, driver_id);
CREATE INDEX idx_rides_pickup_gist ON rides USING GIST (pickup_location);
CREATE INDEX idx_payments_ride ON payments (ride_id);
CREATE INDEX idx_audit_timestamp ON audit_logs (timestamp DESC);
