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
| Full Restore | Yes, from a differential snapshot | [by using point-in-time-restore (PITR)]((https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-backup-restore#point-in-time-recovery)) |
| Point in Time Restore | yes | See the same notes as given in the "Full Restore" feature above. |

### Performance
The performance details very depending on the Flexible Server Type.  In this case these are limits within the "General Purpose" DB Server SKU types.  

| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| Max Storage Size | 32GB to 16TB  | [See the disk space and I/O's per second limits](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-compute-storage#storage)  |
| Max Sessions | 859 to 5,000 | [Connection SKU Limits](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-limits#maximum-connections) |
| Max CPU | 2 to 64 vCores | [Compute SKU Limits](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-compute-storage#compute-tiers-vcores-and-server-types) |
| Max Memory (cache) | 8GB to 256GB | [Compute SKU Limits](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-compute-storage#compute-tiers-vcores-and-server-types) |
| Online Scale Operations | No - must be offline | [Planned downtime events](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-business-continuity#planned-downtime-events) |

### Security & Audit

| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| Data at Rest Encryption | Yes | [Always on, cannot be disabled](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-security#information-protection-and-encryption) |
| Data in Transit Encryption | TLS 1.2 & 1.3  | [TLS 1.3 is recommended](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-networking#tls-and-ssl) |
| Encrypt Column Data | No | |
| S/W Firewall | Yes | [Manage IP ranges](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-firewall-rules) |
| Private Endpoints | Not Supported | [Private VNETs are recommended](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-networking) |
| Azure AD Authentication | Yes | [Only for Flexible Server](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-azure-ad-authentication) |
| DB Audit | Session & Object Level | [Uses the pgAudit extension](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-audit) |
| Security Benchmarks | Yes | [Currently only for Single Server Version](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/postgresql-security-baseline) |

### Intelligence & Automation

| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| Performance Advisor | No |  |
| Auto Tuning | Limited | [Configurable through the Azure Portal](https://learn.microsoft.com/en-gb/azure/postgresql/flexible-server/concepts-intelligent-tuning)  |
| Table Statistics | Yes | [See the Postgres cumulative statistics system](https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-STATS-SETUP) |

### Microsoft Support

| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| DB Product Development | No | Open Source Community only |
| Azure Updates | Yes | [Use the Azure product updates - search](https://azure.microsoft.com/en-gb/updates/?category=databases&query=postgresql) |


