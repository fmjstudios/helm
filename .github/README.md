# FMJ Studios - Helm Charts <img src="https://seeklogo.com/images/H/helm-logo-9208DB3EE5-seeklogo.com.png" alt="Helm Logo" align="right" height="300" width="260"/>

A collection of open-source [MIT][license]-licensed _Helm Charts_ written and maintained by `FMJ Studios` for use with [Kubernetes][kubernetes] `v1.26` and above. The charts adhere to [Helm][helm]'s best practices and prefer the use of raw YAML manifests instead of relying on Helm function libraries or other dependencies. This eases the development overhead and also allows chart users to read and learn from the chart sources. Furthermore flat dependency trees are something all developers can appreciate. Lastly the charts are also published to [Artifacthub][artifacthub] for discoverability purposes and (perhaps) for easier traversal of `values.yaml` or the packages manifests.

---

> ⚠️ NOTE: This repository is in it's very early stages. The use of these charts while only non-stable versions are currently released is of course possible, but highly discouraged.

## 📖 Overview

| Chart                            | Container Images Used                               | Current Version |
|----------------------------------|-----------------------------------------------------|-----------------|
| [Vaultwarden][vaultwarden_chart] | [vaultwarden/server][vaultwarden_images]            | 0.0.1           |
| [Uptime-Kuma][uptimekuma_chart]  | [louislam/uptime-kuma][uptime_kuma_images]          | 0.0.1           |
| [Linkwarden][linkwarden_chart]   | [linkwarden/linkwarden][linkwarden_images]          | 0.0.1           |
| [Gotenberg][gotenberg_chart]     | [gotenberg/gotenberg][gotenberg_images]             | 0.0.1           |
| [Paperless-NGX][paperless_chart] | [paperless-ngx/paperless-ngx][paperless_ngx_images] | 0.0.1           |

## ⚒️ Building

The project uses the `Make` build system with targets defined in the projects top-level [`Makefile`][makefile]. The file includes a debug mode that will print usage information for each `Make` target when the variable `PRINT_HELP=y`  is defined. It will not execute any commands, but solely print the information so no actions will be taken on your machine. Before running _any_ target you should run the `tools-check` target which will look for all executables required to operate the project locally. If any of the required executables are not found the `Make` will let you know.

---

### 📜 License

This project and it's contents are licensed under the Open Source **[MIT][license]** license.

### ✉ Contact

- **Maintainers**: FMJ Studios
- **E-Mail**: [info@fmj.studio](mailto:info@fmj.studio)

<!-- INTERNAL REFERENCES -->

<!-- Chart references -->
[gotenberg_chart]: ./charts/gotenberg/
[linkwarden_chart]: ./charts/linkwarden/
[paperless_chart]: ./charts/paperless-ngx/
[uptimekuma_chart]: ./charts/uptime-kuma/
[vaultwarden_chart]: ./charts/vaultwarden/

<!-- File references -->
[license]: ./LICENSE
[makefile]: ./Makefile

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
