# Task 6: Failure Recovery

- **WAL (Write-Ahead Logging):** Changes written to WAL before commit → crash recovery by replay.
- **Checkpoints:** Reduce recovery time.
- **Backups:** pg_basebackup + WAL archiving for Point-in-Time Recovery.
- Distributed: Each shard recovers independently.
