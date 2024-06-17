# FMJ Studios - Cachet Helm Chart <img src="https://raw.githubusercontent.com/cachethq/art/master/logo-mark/cachet-logomark-green.png" alt="Cachet Logo" width="175" height="175" align="right" loading="lazy">


Cachet is an open-source status page system designed to help you keep track of your system status and share it with your 
user base. It is built to be responsive and works seamlessly across different devices. It is perfect for businesses and 
organizations of all sizes that want to maintain transparency about their system's status with their users, especially 
in cases of downtime or maintenance. As an open-source project, Cachet is freely available for self-hosting.

It delivers all of these features within a single Docker image available on [Docker Hub](https://hub.docker.com/r/cachethq/docker/).

> Head to the [Cachet GitHub Repository](https://github.com/cachethq/cachet) or
> their [Website](https://cachethq.io/) for in-depth [documentation](https://docs.cachethq.io/introduction.html)
> and [configuration guides](https://docs.cachethq.io/installation/docker.html).

# TL;DR

```shell
helm install my-release oci://ghcr.io/fmjstudios/helm/cachet:1.2.3
```

# Introduction

This chart bootstraps a Cachet [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) on
a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh/) package manager. For cluster networking
a [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) manifest is also created, whereas the
Ingress needs to be explicitly enabled. Lastly the chart configures
a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) if
enabled. [RBAC manifests](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) are enabled by default.

The chart supports the configuration of all [Cachet environment variables](https://docs.cachethq.io/installation/docker.html)
via the `cachet` key in Helm's *values* and makes use of the official Docker Hub container image, although this is configurable via the Image
Parameters.

## Parameters

### Cachet Image parameters

| Name                | Description                                                         | Value               |
| ------------------- | ------------------------------------------------------------------- | ------------------- |
| `image.registry`    | The Docker registry to pull the image from                          | `docker.io`         |
| `image.repository`  | The registry repository to pull the image from                      | `fmjstudios/cachet` |
| `image.tag`         | The image tag to pull                                               | `2.4.1`             |
| `image.digest`      | The image digest to pull                                            | `""`                |
| `image.pullPolicy`  | The Kubernetes image pull policy                                    | `IfNotPresent`      |
| `image.pullSecrets` | A list of secrets to use for pulling images from private registries | `[]`                |

### Cachet Name overrides

| Name               | Description                                     | Value |
| ------------------ | ----------------------------------------------- | ----- |
| `nameOverride`     | String to partially override linkstack.fullname | `""`  |
| `fullnameOverride` | String to fully override linkstack.fullname     | `""`  |

### Cachet Configuration parameters

| Name                                     | Description                                                               | Value        |
| ---------------------------------------- | ------------------------------------------------------------------------- | ------------ |
| `cachet.url`                             | The public facing URL for the application                                 | `""`         |
| `cachet.env`                             | Set the environment the application should run within                     | `production` |
| `cachet.debug`                           | Whether the app should be run in debug mode                               | `false`      |
| `cachet.emoji`                           | Enable GitHub Emoji's                                                     | `false`      |
| `cachet.githubToken.value`               | The GitHub API token                                                      | `""`         |
| `cachet.githubToken.existingSecret.name` | The name of an existing Secret containing the token                       | `""`         |
| `cachet.githubToken.existingSecret.key`  | The key name within the previously named existingSecret                   | `""`         |
| `cachet.drivers.cache`                   | The driver used to support caching. `apc` or `redis`.                     | `apc`        |
| `cachet.drivers.session`                 | The driver used to support sessions. `apc` or `redis`.                    | `apc`        |
| `cachet.drivers.queue`                   | The driver used to support queues                                         | `sync`       |
| `cachet.drivers.mail`                    | The driver used to support queues                                         | `smtp`       |
| `cachet.key.value`                       | The application key for encryption (do not change after installation)     | `""`         |
| `cachet.key.existingSecret.name`         | The name of an existing Secret containing the app key                     | `""`         |
| `cachet.key.existingSecret.key`          | The key name within the previously named existingSecret                   | `""`         |
| `cachet.database.driver`                 | The database driver to use `sqlite`, `mysql` or `postgresql`              | `postgresql` |
| `cachet.database.host`                   | The database host, or path in case of `sqlite`                            | `""`         |
| `cachet.database.port`                   | The database port, ignored in case of `sqlite`                            | `""`         |
| `cachet.database.name`                   | The database name                                                         | `""`         |
| `cachet.database.user`                   | The database user                                                         | `""`         |
| `cachet.database.password`               | The database user password                                                | `""`         |
| `cachet.database.existingSecret`         | The name of an existing secret containing a `username` and `password` key | `""`         |
| `cachet.mail.host`                       | The host of an SMTP server                                                | `""`         |
| `cachet.mail.port`                       | The port of an SMTP server                                                | `""`         |
| `cachet.mail.address`                    | The sender address for emails sent by Cachet                              | `""`         |
| `cachet.mail.name`                       | The name for emails sent by Cachet                                        | `""`         |
| `cachet.mail.encryption`                 | The encryption to use for interactions with the SMTP server               | `tls`        |
| `cachet.mail.user`                       | The SMTP user                                                             | `""`         |
| `cachet.mail.password`                   | The SMTP user password                                                    | `""`         |
| `cachet.mail.existingSecret`             | The name of an existing secret containing a `username` and `password` key | `""`         |
| `cachet.redis.host`                      | The Redis host, or path in case of `sqlite`                               | `""`         |
| `cachet.redis.port`                      | The Redis port, ignored in case of `sqlite`                               | `""`         |
| `cachet.redis.database`                  | The Redis database name                                                   | `""`         |

### ConfigMap parameters

| Name                    | Description                             | Value |
| ----------------------- | --------------------------------------- | ----- |
| `configMap.annotations` | Annotations for the ConfigMap resource  | `{}`  |
| `configMap.labels`      | Extra Labels for the ConfigMap resource | `{}`  |

### Secret parameters

| Name                 | Description                                                   | Value |
| -------------------- | ------------------------------------------------------------- | ----- |
| `secret.annotations` | Common annotations for the DB, Mail and GitHub Token secrets  | `{}`  |
| `secret.labels`      | Common extra labels for the DB, Mail and GitHub Token secrets | `{}`  |

### Ingress parameters

| Name                  | Description                                                      | Value   |
| --------------------- | ---------------------------------------------------------------- | ------- |
| `ingress.enabled`     | Whether to enable Ingress                                        | `false` |
| `ingress.className`   | The IngressClass to use for the pod's ingress                    | `""`    |
| `ingress.whitelist`   | A comma-separated list of IP addresses to whitelist              | `""`    |
| `ingress.annotations` | Annotations for the Ingress resource                             | `{}`    |
| `ingress.tls`         | A list of hostnames and secret names to use for TLS              | `[]`    |
| `ingress.extraHosts`  | A list of extra hosts for the Ingress resource (with cachet.url) | `[]`    |

### Service parameters

| Name                     | Description                                      | Value       |
| ------------------------ | ------------------------------------------------ | ----------- |
| `service.type`           | The type of service to create for the deployment | `ClusterIP` |
| `service.port`           | The port to use on the service                   | `8080`      |
| `service.annotations`    | Annotations for the service resource             | `{}`        |
| `service.labels`         | Labels for the service resource                  | `{}`        |
| `service.ipFamilyPolicy` | The Kubernetes ipFamilyPolicy                    | `""`        |

### RBAC parameters

| Name          | Description                             | Value  |
| ------------- | --------------------------------------- | ------ |
| `rbac.create` | Whether or not to create RBAC resources | `true` |
| `rbac.rules`  | Extra rules to add to the Role          | `[]`   |

### Cachet Service Account parameters

| Name                         | Description                                                                 | Value   |
| ---------------------------- | --------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`      | Whether or not a service account should be created                          | `true`  |
| `serviceAccount.automount`   | Whether or not to automount the service account token                       | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account                                   | `{}`    |
| `serviceAccount.name`        | A custom name for the service account, otherwise linkstack.fullname is used | `""`    |
| `serviceAccount.secrets`     | A list of secrets mountable by this service account                         | `[]`    |

### Cachet Liveness Probes

| Name                                | Description                                                 | Value   |
| ----------------------------------- | ----------------------------------------------------------- | ------- |
| `livenessProbe.enabled`             | Enable or disable the use of liveness probes                | `false` |
| `livenessProbe.initialDelaySeconds` | Configure the initial delay seconds for the liveness probe  | `5`     |
| `livenessProbe.timeoutSeconds`      | Configure the initial delay seconds for the liveness probe  | `1`     |
| `livenessProbe.periodSeconds`       | Configure the seconds for each period of the liveness probe | `10`    |
| `livenessProbe.successThreshold`    | Configure the success threshold for the liveness probe      | `1`     |
| `livenessProbe.failureThreshold`    | Configure the failure threshold for the liveness probe      | `10`    |

### Cachet Readiness Probes

| Name                                 | Description                                                  | Value   |
| ------------------------------------ | ------------------------------------------------------------ | ------- |
| `readinessProbe.enabled`             | Enable or disable the use of readiness probes                | `false` |
| `readinessProbe.initialDelaySeconds` | Configure the initial delay seconds for the readiness probe  | `5`     |
| `readinessProbe.timeoutSeconds`      | Configure the initial delay seconds for the readiness probe  | `1`     |
| `readinessProbe.periodSeconds`       | Configure the seconds for each period of the readiness probe | `10`    |
| `readinessProbe.successThreshold`    | Configure the success threshold for the readiness probe      | `1`     |
| `readinessProbe.failureThreshold`    | Configure the failure threshold for the readiness probe      | `3`     |

### Cachet Startup Probes

| Name                               | Description                                                | Value   |
| ---------------------------------- | ---------------------------------------------------------- | ------- |
| `startupProbe.enabled`             | Enable or disable the use of readiness probes              | `false` |
| `startupProbe.initialDelaySeconds` | Configure the initial delay seconds for the startup probe  | `5`     |
| `startupProbe.timeoutSeconds`      | Configure the initial delay seconds for the startup probe  | `1`     |
| `startupProbe.periodSeconds`       | Configure the seconds for each period of the startup probe | `10`    |
| `startupProbe.successThreshold`    | Configure the success threshold for the startup probe      | `1`     |
| `startupProbe.failureThreshold`    | Configure the failure threshold for the startup probe      | `10`    |

### Pod disruption budget parameters

| Name                               | Description                                          | Value  |
| ---------------------------------- | ---------------------------------------------------- | ------ |
| `podDisruptionBudget.enabled`      | Enable the pod disruption budget                     | `true` |
| `podDisruptionBudget.minAvailable` | The minium amount of pods which need to be available | `1`    |

### Pod settings

| Name                 | Description                                            | Value |
| -------------------- | ------------------------------------------------------ | ----- |
| `resources`          | The resource limits/requests for the Cachet pod        | `{}`  |
| `initContainers`     | Define extra initContainers for the main Cachet server | `[]`  |
| `nodeSelector`       | Node labels for pod assignment                         | `{}`  |
| `tolerations`        | Tolerations for pod assignment                         | `[]`  |
| `affinity`           | Affinity for pod assignment                            | `{}`  |
| `strategy`           | Specify a deployment strategy for the Cachet pod       | `{}`  |
| `podAnnotations`     | Extra annotations for the Cachet pod                   | `{}`  |
| `podLabels`          | Extra labels for the Cachet pod                        | `{}`  |
| `priorityClassName`  | The name of an existing PriorityClass                  | `""`  |
| `podSecurityContext` | Security context settings for the Cachet pod           | `{}`  |

### Security context settings

| Name              | Description                           | Value |
| ----------------- | ------------------------------------- | ----- |
| `securityContext` | General security context settings for | `{}`  |

### Bitnami&reg; PostgreSQL parameters

| Name                                 | Description                                                                                            | Value      |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------ | ---------- |
| `postgresql.enabled`                 | Enable or disable the PostgreSQL subchart                                                              | `true`     |
| `postgresql.auth.enablePostgresUser` | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user | `true`     |
| `postgresql.auth.postgresPassword`   | Password for the "postgres" admin user. Ignored if `auth.existingSecret` is provided                   | `postgres` |
| `postgresql.auth.username`           | Name for a custom user to create                                                                       | `cachet`   |
| `postgresql.auth.password`           | Password for the custom user to create. Ignored if `auth.existingSecret` is provided                   | `cachet`   |
| `postgresql.auth.database`           | Name for a custom database to create                                                                   | `cachet`   |
| `postgresql.auth.usePasswordFiles`   | Mount credentials as a files instead of using an environment variable                                  | `false`    |

### PostgreSQL Primary parameters

| Name                                           | Description                                                    | Value               |
| ---------------------------------------------- | -------------------------------------------------------------- | ------------------- |
| `postgresql.primary.name`                      | Name of the primary database (eg primary, master, leader, ...) | `primary`           |
| `postgresql.primary.persistence.enabled`       | Enable PostgreSQL Primary data persistence using PVC           | `true`              |
| `postgresql.primary.persistence.existingClaim` | Name of an existing PVC to use                                 | `""`                |
| `postgresql.primary.persistence.storageClass`  | PVC Storage Class for PostgreSQL Primary data volume           | `""`                |
| `postgresql.primary.persistence.accessModes`   | PVC Access Mode for PostgreSQL volume                          | `["ReadWriteOnce"]` |
| `postgresql.primary.persistence.size`          | PVC Storage Request for PostgreSQL volume                      | `5Gi`               |

### Bitnami&reg; Redis parameters

| Name                  | Description                                                            | Value        |
| --------------------- | ---------------------------------------------------------------------- | ------------ |
| `redis.enabled`       | Enable or disable the Redis&reg; subchart                              | `false`      |
| `redis.architecture`  | Redis&reg; architecture. Allowed values: `standalone` or `replication` | `standalone` |
| `redis.auth.password` | Redis&reg; password                                                    | `""`         |
