# FMJ Studios - GoBackup Helm Chart <img src="https://user-images.githubusercontent.com/5518/205909959-12b92929-4ac5-4bb5-9111-6f9a3ed76cf6.png" alt="GoBackup Logo" width="175" height="175" align="right" loading="lazy"/>

GoBackup is a CLI and Web UI for database backups to local, cloud or remote storage (FTP, SCP, S3, GCS, Aliyun
OSS ...) with encryption support. It supports running these tasks on a schedule defined within a configuration file.
Sending automatic notifications to a wide array of services (Slack, SMTP, Discord, GitHub, ...) is also supported. It
delivers all of these features within a single Docker image available
on [Docker Hub](https://hub.docker.com/r/huacnlee/gobackup).

> Head to the [GoBackup Homepage](https://gobackup.github.io/) for
> in-depth documentation
> and [configuration guides](https://gobackup.github.io/configuration).

## ✨ TL;DR

### Helm Repository Installation

```shell
helm repo add fmjstudios https://fmjstudios.github.io/helm
helm install gobackup fmjstudios/gobackup --version X.Y.Z
```

### OCI Installation

```shell
helm install oci://ghcr.io/fmjstudios/helm/gobackup:X.Y.Z
```

## Introduction

This chart bootstraps a GoBackup [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) on
a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh/) package manager. For cluster networking
a [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) manifest is also created, whereas the
Ingress needs to be explicitly enabled. Lastly the chart configures
a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) if
enabled. [RBAC manifests](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) are enabled by default.

The chart supports the configuration of all [GoBackup configuration options](https://gobackup.github.io/configuration)
via the `gobackup` key in Helm's _values_ and makes use of the official Docker Hub container image, although this is
configurable via the Image Parameters.

## Parameters