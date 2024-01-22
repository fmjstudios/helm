
<img src="https://raw.githubusercontent.com/louislam/uptime-kuma/36196f632d499fddef436a3aacf2f11a01958f07/public/icon.svg" alt="Uptime-Kuma Logo" width="150" height="150" align="right" />

# FMJ Studios - Uptime-Kuma Helm Chart

Uptime-Kuma is an open-source, is an easy-to-use self-hosted monitoring tool. It supports monitoring uptime for HTTP(s) / TCP / HTTP(s) Keyword / HTTP(s) Json Query / Ping / DNS Record / Push / Steam Game Server / Docker Containers, sports a fancy reactive and fast UI and features notifications via Telegram, Discord, Gotify, Slack, Pushover, Email (SMTP), and [90+ notification services](https://github.com/louislam/uptime-kuma/tree/master/src/components/notifications).
Additionally the application is available in [multiple languages](https://github.com/louislam/uptime-kuma/tree/master/src/lang), can map status pages to specific domains and supports proxies and 2FA. It delivers all of these features within a single Docker image available on [Docker Hub](https://hub.docker.com/r/louislam/uptime-kuma).

> Head to the [Uptime-Kuma GitHub Repository](https://github.com/louislam/uptime-kuma/tree/master) for in-depth [documentation](https://github.com/louislam/uptime-kuma/wiki) and [configuration guides](https://github.com/louislam/uptime-kuma/wiki/Environment-Variables).

# TL;DR

```shell
helm install my-release oci://ghcr.io/fmjstudios/helm/uptime-kuma:1.2.3
```

# Introduction

This chart bootstraps a Uptime-Kuma [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) or [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh/) package manager. For cluster networking a [Service](https://kubernetes.io/docs/concepts/services-networking/service/) and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) manifest is also created, whereas the Ingress needs to be explicitly enabled. Lastly the chart configures a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) if enabled. [RBAC manifests](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) are enabled by default.

The chart supports the configuration of all [Uptime-Kuma environment variables]([StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) or) via the `uptimeKuma` key in Helm's *values* and makes use of the official Docker Hub container image, although this is configureble via the Image Parameters.

## Parameters

### Uptime-Kuma Image parameters

| Name                | Description                                                         | Value                 |
| ------------------- | ------------------------------------------------------------------- | --------------------- |
| `image.registry`    | The Docker registry to pull the image from                          | `docker.io`           |
| `image.repository`  | The registry repository to pull the image from                      | `louislam/uptimeKuma` |
| `image.tag`         | The image tag to pull                                               | `'1.23.11'`           |
| `image.digest`      | The image digest to pull                                            | `""`                  |
| `image.pullPolicy`  | The Kubernetes image pull policy                                    | `IfNotPresent`        |
| `image.pullSecrets` | A list of secrets to use for pulling images from private registries | `[]`                  |

### Uptime-Kuma Name overrides

| Name               | Description                                      | Value |
| ------------------ | ------------------------------------------------ | ----- |
| `nameOverride`     | String to partially override uptimeKuma.fullname | `""`  |
| `fullnameOverride` | String to fully override uptimeKuma.fullname     | `""`  |

### Uptime-Kuma Configuration parameters

| Name                                              | Description                                                                                         | Value         |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------- |
| `uptimeKuma.host`                                 | The host address to bind Uptime-Kuma to                                                             | `"::"`        |
| `uptimeKuma.port`                                 | The port for Uptime-Kuma to listen on                                                               | `3001`        |
| `uptimeKuma.disableFrameSameOrigin`               | Allow Uptime-Kuma to be embedded inside HTML 'iframes' of other origins                             | `false`       |
| `uptimeKuma.websocketOriginCheck`                 | Configures Uptime-Kuma to check whether the websocket 'ORIGIN' header matches the server's hostname | `"cors-like"` |
| `uptimeKuma.allowAllChromeExecutables`            | Allow to specify any executables as Chromium                                                        | `"0"`         |
| `uptimeKuma.data.path`                            | The relative path to store data in                                                                  | `data`        |
| `uptimeKuma.data.pvc.size`                        | The size given to PVCs created from the above data                                                  | `5Gi`         |
| `uptimeKuma.data.pvc.storageClass`                | The storageClass given to PVCs created from the above data                                          | `standard`    |
| `uptimeKuma.data.pvc.reclaimPolicy`               | The resourcePolicy given to PVCs created from the above data                                        | `Retain`      |
| `uptimeKuma.data.pvc.existingClaim`               | Provide the name to an existing PVC                                                                 | `""`          |
| `uptimeKuma.certs.key`                            | The path to an TLS certificate key - ignored if 'existingSecret' is set                             | `""`          |
| `uptimeKuma.certs.cert`                           | The path to an TLS certificate cert - ignored if 'existingSecret' is set                            | `""`          |
| `uptimeKuma.certs.passphrase.value`               | The passphrase for the TLS certificate key                                                          | `""`          |
| `uptimeKuma.certs.passphrase.existingSecret.name` | The name of an existing Kubernetes secret                                                           | `""`          |
| `uptimeKuma.certs.passphrase.existingSecret.key`  | The key within the existing Kubernetes secret                                                       | `""`          |
| `uptimeKuma.cloudflaredToken.value`               | The Cloudflare Tunnel token                                                                         | `""`          |
| `uptimeKuma.cloudflaredToken.existingSecret.name` | The name of an existing Kubernetes secret                                                           | `""`          |
| `uptimeKuma.cloudflaredToken.existingSecret.key`  | The key within the existing Kubernetes secret                                                       | `""`          |
| `uptimeKuma.node.extraCaCerts`                    | The path to CA bundle for Node.js to use - in order to verify self-signed certificates              | `""`          |
| `uptimeKuma.node.tlsRejectUnauthorized`           | Ignore all TLS verification errors                                                                  | `""`          |
| `uptimeKuma.node.options`                         | Specify extra CLI options to pass to Node.js                                                        | `[]`          |

### Ingress parameters

| Name                  | Description                                         | Value   |
| --------------------- | --------------------------------------------------- | ------- |
| `ingress.enabled`     | Whether to enable Ingress                           | `false` |
| `ingress.className`   | The IngressClass to use for the pod's ingress       | `""`    |
| `ingress.annotations` | Annotations for the Ingress resource                | `{}`    |
| `ingress.hosts`       | A list of hosts for the Ingress resource            | `[]`    |
| `ingress.tls`         | A list of hostnames and secret names to use for TLS | `[]`    |

### Service parameters

| Name                  | Description                                      | Value       |
| --------------------- | ------------------------------------------------ | ----------- |
| `service.type`        | The type of service to create for the deployment | `ClusterIP` |
| `service.port`        | The port to use on the service                   | `80`        |
| `service.annotations` | Annotations for the service resource             | `{}`        |
| `service.labels`      | Labels for the service resource                  | `{}`        |

### RBAC parameters

| Name          | Description                             | Value   |
| ------------- | --------------------------------------- | ------- |
| `rbac.create` | Whether or not to create RBAC resources | `false` |
| `rbac.rules`  | Extra rules to add to the Role          | `[]`    |

### Uptime-Kuma Service Account parameters

| Name                         | Description                                                                  | Value  |
| ---------------------------- | ---------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Whether or not a service account should be created                           | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account                                    | `{}`   |
| `serviceAccount.name`        | A custom name for the service account, otherwise uptimeKuma.fullname is used | `""`   |
| `serviceAccount.secrets`     | A list of secrets mountable by this service account                          | `""`   |

### Uptime-Kuma Liveness Probes

| Name                                | Description                                                 | Value   |
| ----------------------------------- | ----------------------------------------------------------- | ------- |
| `livenessProbe.enabled`             | Enable or disable the use of liveness probes                | `false` |
| `livenessProbe.initialDelaySeconds` | Configure the initial delay seconds for the liveness probe  | `5`     |
| `livenessProbe.timeoutSeconds`      | Configure the initial delay seconds for the liveness probe  | `1`     |
| `livenessProbe.periodSeconds`       | Configure the seconds for each period of the liveness probe | `10`    |
| `livenessProbe.successThreshold`    | Configure the success threshold for the liveness probe      | `1`     |
| `livenessProbe.failureThreshold`    | Configure the failure threshold for the liveness probe      | `10`    |

### Uptime-Kuma Readiness Probes

| Name                                 | Description                                                  | Value   |
| ------------------------------------ | ------------------------------------------------------------ | ------- |
| `readinessProbe.enabled`             | Enable or disable the use of readiness probes                | `false` |
| `readinessProbe.initialDelaySeconds` | Configure the initial delay seconds for the readiness probe  | `5`     |
| `readinessProbe.timeoutSeconds`      | Configure the initial delay seconds for the readiness probe  | `1`     |
| `readinessProbe.periodSeconds`       | Configure the seconds for each period of the readiness probe | `10`    |
| `readinessProbe.successThreshold`    | Configure the success threshold for the readiness probe      | `1`     |
| `readinessProbe.failureThreshold`    | Configure the failure threshold for the readiness probe      | `3`     |

### Uptime-Kuma Startup Probes

| Name                               | Description                                                | Value  |
| ---------------------------------- | ---------------------------------------------------------- | ------ |
| `startupProbe.enabled`             | Enable or disable the use of readiness probes              | `true` |
| `startupProbe.initialDelaySeconds` | Configure the initial delay seconds for the startup probe  | `5`    |
| `startupProbe.timeoutSeconds`      | Configure the initial delay seconds for the startup probe  | `1`    |
| `startupProbe.periodSeconds`       | Configure the seconds for each period of the startup probe | `10`   |
| `startupProbe.successThreshold`    | Configure the success threshold for the startup probe      | `1`    |
| `startupProbe.failureThreshold`    | Configure the failure threshold for the startup probe      | `10`   |

### Pod disruption budget parameters

| Name                               | Description                                          | Value  |
| ---------------------------------- | ---------------------------------------------------- | ------ |
| `podDisruptionBudget.enabled`      | Enable the pod disruption budget                     | `true` |
| `podDisruptionBudget.minAvailable` | The minium amount of pods which need to be available | `1`    |

### Pod settings

| Name                 | Description                                           | Value |
| -------------------- | ----------------------------------------------------- | ----- |
| `resources`          | The resource limits/requests for the Uptime-Kuma pod  | `{}`  |
| `initContainers`     | Define initContainers for the Uptime-Kuma pod         | `[]`  |
| `nodeSelector`       | Node labels for pod assignment                        | `{}`  |
| `tolerations`        | Tolerations for pod assignment                        | `[]`  |
| `affinity`           | Affinity for pod assignment                           | `{}`  |
| `strategy`           | Specify a deployment strategy for the Uptime-Kuma pod | `{}`  |
| `podAnnotations`     | Extra annotations for the Uptime-Kuma pod             | `{}`  |
| `podLabels`          | Extra labels for the Uptime-Kuma pod                  | `{}`  |
| `podSecurityContext` | Security context settings for the Uptime-Kuma pod     | `{}`  |

### Security context settings

| Name              | Description                           | Value |
| ----------------- | ------------------------------------- | ----- |
| `securityContext` | General security context settings for | `{}`  |
