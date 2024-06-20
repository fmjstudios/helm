# ✅ FMJ Studios Helm Charts - TODO's

## ➕ Additions

- [ ] [Karma (Alertmanager Dashboard)](https://github.com/prymitive/karma) chart
- [ ] [BookStack](https://www.bookstackapp.com/) chart
- [ ] [Maildev](https://github.com/maildev/maildev) chart
- [ ] [GoBackup](https://gobackup.github.io/) chart
- [ ] [Kubenav](https://github.com/kubenav/kubenav) chart
- [ ] [Shopware 6](https://github.com/shopware/shopware) chart
- [ ] [Shlink](https://shlink.io/) chart
- [ ] [AnonAddy](https://addy.io/) chart
- [ ] [OpenGist](https://github.com/thomiceli/opengist) chart
- ~~[X] [Drift](https://github.com/MaxLeiter/Drift)
  chart~~ -> [abandoned](https://github.com/MaxLeiter/Drift/commits/refactor/)
- [ ] [FreshRSS](https://freshrss.org/index.html) chart
- [ ] [Outline](https://www.getoutline.com/) chart
- ~~[X] [Weblate](https://weblate.org/en/) chart~~ -> [official chart][weblate_artifacthub] available
- ~~[X] [Pterodactyl](https://pterodactyl.io/) chart~~ -> cannot be hosted on Kubernetes
- [ ] [Metabase](https://metabase.com) chart
- [ ] [DBGate](https://github.com/dbgate/dbgate) chart
- [ ] [Statping-ng](https://github.com/statping-ng/statping-ng/wiki) chart

> [!NOTE]
> Most important are `GoBackup`, `Shopware 6` and `Pterodactyl`

## 🔁 Changes (across all charts)

- [X] Allow for the creation
  of [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) -> out of scope
- [X] Enable the use of PSP-labels by default as long as charted applications support it -> Provide suggested settings
  in the documentation comments instead, since everybody's security needs might be different
- [X] Add setting to automount service account tokens
- [ ] Add optional settings to define extra arguments for the deployed containers
- [X] Add ability to
  specify [handlers for Pod lifecycle events](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/) ->
  uncommon + potentially dangerous
- [ ] Add [Pod/ServiceMonitor and PrometheusRule manifests](https://prometheus-operator.dev/docs/operator/api/) for each
  chart
- [X] Enforce the use of well-defined security contexts for pods an containers like
  in [Bitnami's&reg; Redis](https://github.com/bitnami/charts/blob/main/bitnami/redis/values.yaml) -> Provide suggested
  settings
  in the documentation comments instead, since everybody's security needs might be different
- [X] Possibly add configuration
  for [Pod priority](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)
- [X] Enhance service configurations like
  in [Bitnami's&reg; Redis](https://github.com/bitnami/charts/blob/main/bitnami/redis/values.yaml#L517)
- [X] Add Linkstack's ConfigMap parameters to all other charts

## 💡 Ideas

_None_

## 🔗 Links

_None_

[//]: # (GitHub Links)

[vikunja_artifacthub]: https://artifacthub.io/packages/helm/vikunja/vikunja

[weblate_artifacthub]: https://artifacthub.io/packages/helm/weblate/weblate
