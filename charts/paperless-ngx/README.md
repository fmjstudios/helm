# FMJ Studios - Paperless-NGX Helm Chart <img src="https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/5842944d1ef817c11a47ed5c19ba8b7886c9fbfe/resources/logo/web/svg/square.svg" alt="Paperless-NGX Logo" width="175" height="175" align="right" />

Paperless-ngx is a community-supported open-source document management system that transforms your physical documents into a searchable online archive so you can keep, well, less paper. Paperless-NGX is the official successor to the original [Paperless](https://github.com/the-paperless-project/paperless) & [Paperless-ng](https://github.com/jonaswinkler/paperless-ng) projects and is designed to distribute the responsibility of advancing and supporting the project among a team of people. The application organizes and indexes your documents with tags, correspondents, types and more, performs OCR on your documents, making their text searchable and selectable and due its' use of the Tesseract engine - recognizes more than 100 languages. On top of all that it features a beautiful modern web application and is accompanied by a plethora of mobile applications for iOS and Android, provided by the open-source community around the project. It delivers all of these features within a single Docker image available on [GitHub Container Registry](https://github.com/paperless-ngx/paperless-ngx/pkgs/container/paperless-ngx).

> Head to the [Paperless-NGX GitHub Repository](https://github.com/paperless-ngx/paperless-ngx/tree/dev) or ther [Website](https://docs.paperless-ngx.com/) for in-depth [documentation](https://docs.paperless-ngx.com/) and [configuration guides](https://docs.paperless-ngx.com/configuration/).

# TL;DR

```shell
helm install my-release oci://ghcr.io/fmjstudios/helm/paperless-ngx:1.2.3
```

# Introduction

This chart bootstraps a Paperless-NGX [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh/) package manager. For cluster networking a [Service](https://kubernetes.io/docs/concepts/services-networking/service/) and [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) manifest is also created, whereas the Ingress needs to be explicitly enabled. Lastly the chart configures a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) if enabled. [RBAC manifests](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) are enabled by default.

The chart supports the configuration of all [Paperless-NGX environment variables](https://docs.paperless-ngx.com/configuration/) via the `paperless` key in Helm's *values* and makes use of the official Docker Hub container image, although this is configurable via the Image Parameters.

## Parameters
