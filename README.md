# FMJ Studios - Helm Charts <img src="https://raw.githubusercontent.com/cncf/artwork/892ce913bbce895ddbd99f981917fcf93050a8ca/projects/helm/icon/color/helm-icon-color.svg" alt="Helm Logo" align="right" width="225"/>

A collection of open-source [MIT][license]-licensed _Helm Charts_ written and maintained by `FMJ Studios` for use
with [Kubernetes][kubernetes] `v1.26` and above.

---

> ⚠️ NOTE: This repository is in it's very early stages. The use of these charts while only non-stable versions are
> currently released is of course possible, but highly discouraged.

## 📖 Overview

| Chart                                                                                                                                                                                                                                                                  | Current Version | Default Container Images                            |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------:|-----------------------------------------------------|
| [Vaultwarden <img src="https://raw.githubusercontent.com/dani-garcia/vaultwarden/890e668071cffe2833834348e19bbef3c061d014/resources/vaultwarden-icon.svg" alt="Vaultwarden Logo" width="32px" height="32px" align="right" loading="lazy">][vaultwarden_chart]          |      0.1.0      | [vaultwarden/server][vaultwarden_images]            |
| [Uptime-Kuma <img src="https://raw.githubusercontent.com/louislam/uptime-kuma/36196f632d499fddef436a3aacf2f11a01958f07/public/icon.svg" alt="Uptime-Kuma Logo" width="32px" height="32px" align="right" loading="lazy">][uptimekuma_chart]                             |      0.0.1      | [louislam/uptime-kuma][uptime_kuma_images]          |
| [Linkwarden <img src="https://raw.githubusercontent.com/linkwarden/linkwarden/main/assets/logo.png" alt="Linkwarden Logo" width="32px" height="32px" align="right" loading="lazy">][linkwarden_chart]                                                                  |      0.0.1      | [linkwarden/linkwarden][linkwarden_images]          |
| [Gotenberg <img src="https://user-images.githubusercontent.com/8983173/130322857-185831e2-f041-46eb-a17f-0a69d066c4e5.png" alt="Gotenberg Logo" width="32px" height="32px" align="right" loading="lazy">][gotenberg_chart]                                             |      0.0.1      | [gotenberg/gotenberg][gotenberg_images]             |
| [Paperless-NGX <img src="https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/5842944d1ef817c11a47ed5c19ba8b7886c9fbfe/resources/logo/web/svg/square.svg" alt="Paperless-NGX Logo" width="32px" height="32px" align="right" loading="lazy">][paperless_chart] |      0.0.1      | [paperless-ngx/paperless-ngx][paperless_ngx_images] |
| [LinkStack <img src="https://raw.githubusercontent.com/LinkStackOrg/branding/main/logo/svg/logo_color_bg_1.svg" alt="Linkstack Logo" width="32px" height="32px" align="right" loading="lazy">][linkstack_chart]                                                        |      0.0.1      | [linkstackorg/linkstack][linkstack_images]          |
| [ntfy <img src="https://raw.githubusercontent.com/binwiederhier/ntfy/main/web/public/static/images/ntfy.png" alt="ntfy Logo" width="32px" height="32px" align="right" loading="lazy">][ntfy_chart]                                                                     |      0.0.1      | [binwiederhier/ntfy][ntfy_images]                   |
| [Cachet <img src="https://raw.githubusercontent.com/cachethq/art/master/logo-mark/cachet-logomark-green.png" alt="Cachet Logo" width="32px" height="32px" align="right" loading="lazy">][cachet_chart]                                                                 |      0.0.1      | [cachethq/docker][cachet_images]                    |

[//]: # (Stolen from https://github.com/gabe565/charts/blob/main/README.md because I really liked the look)

## ❔ Why

The charts adhere to [Helm][helm]'s best practices and prefer the use of raw YAML manifests instead of relying on Helm
function libraries or other dependencies. This eases the development overhead and also allows chart users to read and
learn from the chart sources. On top of that flat dependency trees are something all developers can appreciate. Lastly
the charts are also published to [Artifacthub][artifacthub] for discoverability purposes and (perhaps) for easier
traversal of `values.yaml` or the packages manifests.

## ⚒️ Building

The project uses the `Make` build system with targets defined in the projects top-level [`Makefile`][makefile]. The file
includes a debug mode that will print usage information for each `Make` target when the variable `PRINT_HELP=y`  is
defined. It will not execute any commands, but solely print the information so no actions will be taken on your machine.
Before running _any_ target you should run the `tools-check` target which will look for all executables required to
operate the project locally. If any of the required executables are not found the `Make` will let you know.

---

### 📜 License

This project and it's contents are licensed under the Open Source **[MIT][license]** license.

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

[makefile]: Makefile

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
