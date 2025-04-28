| Key | Description |
|-----|-------------|
| instances | The number of Postgres instances in the cluster |
| operator.deploy | Should the operator be deployed? |
| backup | Configure backing up to a Cloud bucket using BarMan. See https://cloudnative-pg.io/documentation/current/backup_barmanobjectstore/ |
| backup.bucket | The name of the bucket to use for backups |
| backup.credentials | The credentials to use for the bucket. The credentials provided will depend on the cloud provider.  This is an example for using a Google bucket from a GKE cluster. |
| recovery | When set to true the cluster will be restored from the latest backup rather bootstrapping the cluster from scratch. |
| database | The database configuration |
| postgresql.username | The name of the Postgres user to use for the database |
| postgresql.password | The password for the Postgres user. If not specified a random password will be generated |
| persistence | Configuration for the persistent volume |
| persistence.disk | Configuration to use an existing persistent disk. If omitted it is assumed the storage class can dynamically provision storage. |
| persistence.disk.handle | The volumeHandle for the persistent disk |
| persistence.disk.driver | See your cloud provider documentation for the correct CSI driver to use |
| storage | The configuration the pgcluster will use to define its PVC |
