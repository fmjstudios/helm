# Helm Charts <img src="https://raw.githubusercontent.com/cncf/artwork/892ce913bbce895ddbd99f981917fcf93050a8ca/projects/helm/icon/color/helm-icon-color.svg" alt="Helm Logo" align="right" width="225"/>

[![License](https://img.shields.io/github/license/fmjstudios/helm?label=License)](https://opensource.org/licenses/MIT)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/fmjstudios)](https://artifacthub.io/packages/search?repo=fmjstudios&sort=relevance)
[![CI Status](https://github.com/fmjstudios/helm/actions/workflows/release.yaml/badge.svg)](https://github.com/fmjstudios/helm/blob/main/.github/workflows/ci-pipeline.yml)
[![Renovate](https://img.shields.io/badge/Renovate-enabled-brightgreen?logo=renovatebot&logoColor=1DDEDD)](https://renovatebot.com/)

A collection of open-source [MIT][license]-licensed [_Helm Charts_][helm] written and maintained by `FMJ Studios` for
use with [Kubernetes][kubernetes] `v1.26` and above. Have a look [at the table below](#-overview) to get a list of the
included charts, their versions and the default container images. The charts are also published
to [ArtifactHub][artifacthub], where they can be found in
the [`fmjstudios`](https://artifacthub.io/packages/search?repo=fmjstudios&sort=relevance) repository. This GitHub
repository relies on the _GNU Make_ build system to ease the development workflows. The [`Makefile`](Makefile) also
includes `targets` to set up the development environment. Refer to the [CONTRIBUTING.md](docs/CONTRIBUTING.md) for more
information.

## ✨ TL;DR

### Helm Repository Installation

```shell
helm repo add fmjstudios https://fmjstudios.github.io/helm
helm install <RELEASE_NAME> fmjstudios/<CHART_NAME>
```

### OCI Installation

```shell
helm install oci://ghcr.io/fmjstudios/helm/<CHART_NAME>:<VERSION>
```

## 📖 Overview

| Chart                                                                                                                                                                                                                                                                  | Current Version | Default Container Images                            |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------:|-----------------------------------------------------|
| [Vaultwarden <img src="https://raw.githubusercontent.com/dani-garcia/vaultwarden/890e668071cffe2833834348e19bbef3c061d014/resources/vaultwarden-icon.svg" alt="Vaultwarden Logo" width="32px" height="32px" align="right" loading="lazy">][vaultwarden_chart]          |      0.1.2      | [vaultwarden/server][vaultwarden_images]            |
| [Uptime-Kuma <img src="https://raw.githubusercontent.com/louislam/uptime-kuma/36196f632d499fddef436a3aacf2f11a01958f07/public/icon.svg" alt="Uptime-Kuma Logo" width="32px" height="32px" align="right" loading="lazy">][uptimekuma_chart]                             |      0.1.2      | [louislam/uptime-kuma][uptime_kuma_images]          |
| [Linkwarden <img src="https://raw.githubusercontent.com/linkwarden/linkwarden/main/assets/logo.png" alt="Linkwarden Logo" width="32px" height="32px" align="right" loading="lazy">][linkwarden_chart]                                                                  |      0.1.2      | [linkwarden/linkwarden][linkwarden_images]          |
| [Gotenberg <img src="https://user-images.githubusercontent.com/8983173/130322857-185831e2-f041-46eb-a17f-0a69d066c4e5.png" alt="Gotenberg Logo" width="32px" height="32px" align="right" loading="lazy">][gotenberg_chart]                                             |      0.1.2      | [gotenberg/gotenberg][gotenberg_images]             |
| [Paperless-NGX <img src="https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/5842944d1ef817c11a47ed5c19ba8b7886c9fbfe/resources/logo/web/svg/square.svg" alt="Paperless-NGX Logo" width="32px" height="32px" align="right" loading="lazy">][paperless_chart] |      0.1.2      | [paperless-ngx/paperless-ngx][paperless_ngx_images] |
| [LinkStack <img src="https://raw.githubusercontent.com/LinkStackOrg/branding/main/logo/svg/logo_color_bg_1.svg" alt="Linkstack Logo" width="32px" height="32px" align="right" loading="lazy">][linkstack_chart]                                                        |      0.1.2      | [linkstackorg/linkstack][linkstack_images]          |
| [ntfy <img src="https://raw.githubusercontent.com/binwiederhier/ntfy/main/web/public/static/images/ntfy.png" alt="ntfy Logo" width="32px" height="32px" align="right" loading="lazy">][ntfy_chart]                                                                     |      0.1.2      | [binwiederhier/ntfy][ntfy_images]                   |
| [Cachet <img src="https://raw.githubusercontent.com/cachethq/art/master/logo-mark/cachet-logomark-green.png" alt="Cachet Logo" width="32px" height="32px" align="right" loading="lazy">][cachet_chart]                                                                 |      0.1.2      | [cachethq/docker][cachet_images]                    |

[//]: # ("Stolen" from https://github.com/gabe565/charts/blob/main/README.md because I really liked the look)

### 🔃 Contributing

Refer to our [documentation for contributors](docs/CONTRIBUTING.md) for contributing guidelines, commit message
formats and versioning tips.

### 📥 Maintainers

This project is owned and maintained by [FMJ Studios](https://github.com/fmjstudios) refer to
the [`AUTHORS`](.github/AUTHORS) or [`CODEOWNERS`](.github/CODEOWNERS) for more information. You may also use the linked
contact details to reach out directly.

<!-- INTERNAL REFERENCES -->

<!-- Chart references -->

[gotenberg_chart]: charts/gotenberg

[linkwarden_chart]: charts/linkwarden

[paperless_chart]: charts/paperless-ngx

[uptimekuma_chart]: charts/uptime-kuma

[vaultwarden_chart]: charts/vaultwarden

[linkstack_chart]: charts/linkstack

[ntfy_chart]: charts/ntfy

[cachet_chart]: charts/cachet

<!-- File references -->

[license]: LICENSE

<!-- General links -->

[kubernetes]: https://kubernetes.io

[helm]: https://helm.sh

[artifacthub]: https://artifacthub.io/

<!-- Overview links -->

[vaultwarden_images]: https://hub.docker.com/r/vaultwarden/server

[uptime_kuma_images]: https://hub.docker.com/r/louislam/uptime-kuma

[linkwarden_images]: https://github.com/linkwarden/linkwarden/pkgs/container/linkwarden

[gotenberg_images]: https://hub.docker.com/r/gotenberg/gotenberg

[paperless_ngx_images]: https://github.com/paperless-ngx/paperless-ngx/pkgs/container/paperless-ngx

[linkstack_images]: https://hub.docker.com/r/linkstackorg/linkstack

[ntfy_images]: https://hub.docker.com/r/binwiederhier/ntfy

[cachet_images]: https://hub.docker.com/r/cachethq/docker
