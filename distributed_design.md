# Task 5: Distributed Database Design

**Horizontal Fragmentation (Sharding) by city_id:**
- Addis Ababa shard (high traffic)
- Adama shard
- Hawassa shard

**Replication:** Each shard has primary + 2 replicas for availability (unreliable networks).

**Benefit:** Low latency for local rides, scalable for peak hours.
