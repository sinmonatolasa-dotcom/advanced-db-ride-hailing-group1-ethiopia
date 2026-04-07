# 🚖 Ride-Hailing Platform Database - Group 1 (Ethiopia)

**Advanced Database Systems Assignment**  
**Scalable Ride-Hailing Platform for Ethiopian Cities**  
(Addis Ababa, Adama, Hawassa)

**Group Members:**  
- [Add all group member names here]

**Instructor:** [Mr.Birhanu ]  
**Date:** April 2026

## Project Overview
This project designs a scalable, ACID-compliant, geo-distributed database for a ride-hailing platform similar to Uber, operating in Ethiopian cities.  

It handles:
- High concurrency during peak hours (thousands of ride requests)
- Real-time driver location updates
- Fraud prevention and audit logging
- Surge pricing
- Prevention of double-booking
- Geographic distribution across cities

**Technologies Used:** PostgreSQL 16 + PostGIS (for geo-location) + pg_crypto (for encryption)

## Repository Contents
- **ER_Diagram.md** – Entity Relationship Diagram
- **schema.sql** – Database schema with indexes
- **data_population.sql** – Sample data
- **queries.sql** – Optimized queries
- **concurrency_simulation.md** – Concurrency control
- **security.sql** – Security and RBAC
- **distributed_design.md** – Distributed database design
- **failure_recovery.md** – Failure recovery strategies
- **full_report.md** – Complete project report
- **presentation_outline.md** – PPT slide outline

**How to Run:**
1. Install PostgreSQL with PostGIS extension
2. Run `psql -f schema.sql`
3. Run `psql -f data_population.sql`

The repository is **Public** .
