# Azure PaaS Database Features

## Postgres
For an overview of the archicture of Postgres on Azure see the main docs:  
https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/overview  

There are many versions of Postgres available but this document covers the Flexible Server (which provides Azure HA, flexible performance options and cost optimizations such as scalability controls), being a replacement for the previous Single Server version.  As of December 2022, Flexible Server provides Postgres versions 11 to 14.  

### Business Continuity Features

| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| Availability % | 99.99 (ZRS with HA) / 99.95 (LRS with HA / 99.9 (LRS)  | [High Availability Concepts](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-high-availability)  |
| ZRS HA Recovery | RPO of 0 minutes data loss, RTO up to 120 seconds | [Failover Process](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-high-availability#failover-process---unplanned-downtimes) |
| Non-HA Recovery | RPO up to 15 minutes | [Depends on the backup/snapshot frequency and the duration of the WAL (write-ahead-log)](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-backup-restore#backup-frequency) |
| Replica DB for Failover | Only in HA mode | [Standby Replicas](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-high-availability#high-availability---limitations) |
| Read Replica | Yes, but the replica cannot be the HA failover DB | [Read Replicas](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-read-replicas) |
| Auto Failover | Only in HA mode  | See the Failover Process for the "ZRS HA Recovery" feature, above. |

### Backups

| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| Full | No  | [Use the Postgres pg_dump tool](https://learn.microsoft.com/en-gb/azure/postgresql/migrate/how-to-migrate-using-dump-and-restore)  |
| Differential | Once every 24 hours (snapshot) | [Backup Frequency Notes](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-backup-restore#backup-frequency) |
| Transaction Log | Every 15 minutes (or WAL archive) | [See the notes on Write-Ahead-Log archive](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-backup-restore#backup-overview) |
| Backup Durability | LRS = 11 nines / ZRS = 12 nines / GRS = 16 nines | [Backpup redundancy options](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-backup-restore#backup-redundancy-options) |
| Backup Retention | 7 to 35 days | [7 days is the default](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-backup-restore#backup-retention) |
| Full Restore | Yes, from a differential snapshot | [by using point-in-time-restore]((https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-backup-restore#point-in-time-recovery)) |
| Point in Time Restore | yes | See the same notes as given in the "Full Restore" feature above. |


