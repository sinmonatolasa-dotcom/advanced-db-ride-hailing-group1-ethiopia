# ER Diagram (Task 1) - Professional Design

```mermaid
erDiagram
    CITIES ||--o{ USERS : "located_in"
    CITIES ||--o{ DRIVERS : "located_in"
    USERS ||--o{ RIDES : "requests"
    DRIVERS ||--o{ RIDES : "accepts"
    DRIVERS ||--o{ DRIVER_LOCATION_HISTORY : "updates"
    RIDES ||--|| PAYMENTS : "has"
    RIDES ||--o{ RATINGS : "receives"
    RIDES ||--o{ AUDIT_LOGS : "generates"
    USERS ||--o{ AUDIT_LOGS : "generates"
    DRIVERS ||--o{ AUDIT_LOGS : "generates"

    CITIES {
        int city_id PK
        varchar name "Addis Ababa, Adama, Hawassa"
    }
    USERS {
        int user_id PK
        varchar full_name
        int city_id FK
        bytea phone_encrypted "Encrypted with pg_crypto"
        varchar email
        decimal rating "1.0 - 5.0"
        timestamp created_at
    }
    DRIVERS {
        int driver_id PK
        varchar full_name
        varchar vehicle_model "Toyota Vitz"
        varchar license_plate
        int city_id FK
        varchar status "available / busy / offline"
        geography current_location "PostGIS POINT, 4326"
        decimal rating "1.0 - 5.0"
        timestamp last_updated
    }
    RIDES {
        int ride_id PK
        int rider_id FK
        int driver_id FK
        geography pickup_location
        geography dropoff_location
        varchar status "requested / accepted / in_progress / completed / cancelled"
        decimal base_fare_etb
        decimal surge_multiplier "1.0 - 3.0"
        decimal total_fare_etb "Generated column"
        timestamp requested_at
        timestamp accepted_at
        timestamp completed_at
        int estimated_duration_min
    }
    PAYMENTS {
        int payment_id PK
        int ride_id FK
        decimal amount_etb
        varchar status "pending / paid / failed"
        bytea encrypted_details
        timestamp paid_at
    }
    DRIVER_LOCATION_HISTORY {
        int history_id PK
        int driver_id FK
        geography location
        timestamp recorded_at
    }
    RATINGS {
        int rating_id PK
        int ride_id FK
        int driver_id FK
        decimal score "1.0 - 5.0"
        text comment
        timestamp rated_at
    }
    AUDIT_LOGS {
        int log_id PK
        int performed_by "user_id or driver_id"
        varchar action_type
        jsonb old_data
        jsonb new_data
        timestamp timestamp
    }
