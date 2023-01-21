
# MySQL Flexible Server
MySQL Community Version 5.7 and 8.0, Azure "General Purpose" SKU Type.


| Feature | Details | Notes |
|:-------------|:--------------|:-------|
| |**Business Continuity** |
| Availability % | 99.99 (ZRS with HA) / 99.95 (LRS with HA) / 99.9 (LRS no redundancy)  | [MySQL Service Level Agreements](https://azure.microsoft.com/en-gb/support/legal/sla/mysql/v1_2/)  |
| ZRS HA Recovery | RPO of 0 minutes data loss, RTO up to 120 seconds | [Business Continuity Overview](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-business-continuity#unplanned-downtime-failure-scenarios-and-service-recovery) |
| Non-HA Recovery | RPO/RTO not stated | [Depends on database size and number of transaction logs](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#restore) |
| Replica DB for Failover | Only in HA mode | [Zone Redundant Architecture](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability#zone-redundant-ha-architecture) |
| Read Replica | Yes, but the replica cannot be the HA failover DB | [Read Replicas](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-read-replicas) |
| Auto Failover | Only in HA mode, may take between 60 to 120 seconds  | [Automatic Failure Notes](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability#unplanned-automatic-failover) |
| | **Backups** |
| Full | Yes, but must be manually scheduled | [Use on-demand backups via the Portal](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#on-demand-backup)  |
| Differential | Once every 24 hours (snapshot) | [Backup Frequency Notes](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#backup-frequency) |
| Transaction Log | Every 5 minutes | [Backup Frequency Notes](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#backup-frequency) |
| Backup Durability | LRS = 11 nines / ZRS = 12 nines / GRS = 16 nines | [Backpup redundancy options](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#backup-redundancy-options) |
| Backup Retention | 7 to 35 days | [7 days is the default](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#backup-retention) |
| Full Restore | Yes, creates a new DB in the same region | [by using point-in-time-restore (PITR)](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#restore) |
| Point in Time Restore | yes | [PITR](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-backup-restore#restore) |
| | **Performance** |
| Max Storage Size | 20GB to 16TB  | [See the MySQL SKU comparison table](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage)  |
| Max Sessions | 1,365 to 43,691 | [Service Tiers comparison](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage#service-tiers-size-and-server-types) |
| Max CPU | 2 to 64 vCores | [SKU comparison table](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage) |
| Max Memory | 4GB per vCore | [SKU comparison table](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage) |
| Online Scale Operations | Yes but needs server restart (increases to storage & IOPS can auto-scale) | [Resource Scaling Notes](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage#scale-resources) |
| | **Security & Audit** |
| Data at Rest Encryption | Yes | [Always on, cannot be disabled](https://learn.microsoft.com/en-us/azure/mysql/single-server/concepts-security#at-rest) |
| Data in Transit Encryption | up to TLS 1.2  | [Configuring SSL](https://learn.microsoft.com/en-us/azure/mysql/single-server/concepts-ssl-connection-security#tls-settings) |
| Encrypt Column Data | No | |
| S/W Firewall | Yes | [Manage IP ranges](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-networking-public#firewall-rules) |
| Private Endpoints | Not Supported | [Private VNETs are recommended](https://learn.microsoft.com/en-gb/azure/mysql/flexible-server/concepts-networking-vnet) |
| Azure AD Authentication | Yes | [Only for Flexible Server](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-azure-ad-authentication) |
| DB Audit | Yes, although full audit is not recommended | [Audit Database activity](https://learn.microsoft.com/en-gb/azure/mysql/flexible-server/concepts-audit-logs) |
| Security Benchmarks | Yes | [Azure Security Baselines](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/mysql-security-baseline) |
| | **Intelligence** |
| Performance Advisor | No |  |
| Auto Tuning | No |   |
| Table Statistics | Yes | [See the MySQL optimizer statistics docs](https://dev.mysql.com/doc/refman/8.0/en/optimizer-statistics.html) |
| | **Microsoft Support** |
| DB Product Development | No | Open Source Community only |
| Azure Updates | Yes | [Use the Azure product updates - search](https://azure.microsoft.com/en-gb/updates/?category=databases&query=mysql) |