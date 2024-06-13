# FMJ Studios - ntfy Helm Chart <img src="https://raw.githubusercontent.com/binwiederhier/ntfy/main/web/public/static/images/pwa-192x192.png" alt="ntfy Logo" width="175" height="175" align="right" loading="lazy">

ntfy (pronounced notify) is a simple HTTP-based pub-sub notification service. It allows you to send notifications to
your phone or desktop via scripts from any computer, and/or using a REST API. It's infinitely flexible, and 100% free
software.
It delivers all of these features within a single Docker image available
on [Docker Hub](https://hub.docker.com/r/binwiederhier/ntfy).

> Head to the [ntfy GitHub Repository](hhttps://github.com/binwiederhier/ntfy) or
> their [Website](https://ntfy.sh/) for in-depth [documentation](https://docs.ntfy.sh/)
> and [configuration guides](https://docs.ntfy.sh/config/).

# TL;DR

```shell
helm install my-release oci://ghcr.io/fmjstudios/helm/ntfy:1.2.3
```

# Introduction

This chart bootstraps a
Paperless-NGX [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) on
a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh/) package manager. For cluster networking
a [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) manifest is also created, whereas the
Ingress needs to be explicitly enabled. Lastly the chart configures
a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) if
enabled. [RBAC manifests](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) are enabled by default.

The chart supports the configuration of
all [ntfy environment variables](hhttps://docs.ntfy.sh/config/) via the `ntfy` key in
Helm's *values* and makes use of the official Docker Hub container image, although this is configurable via the Image
Parameters.

## Parameters
