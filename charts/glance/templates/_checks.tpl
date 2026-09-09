{{- define "glance.checks" -}}
{{- if and .Values.config.existingConfigMap .Values.config.existingSecret -}}
{{- fail "config.existingConfigMap and config.existingSecret are mutually exclusive" -}}
{{- end -}}
{{- if and (or .Values.config.existingConfigMap .Values.config.existingSecret) .Values.config.files -}}
{{- fail "config.files cannot be used with an external configuration source" -}}
{{- end -}}
{{- if hasKey .Values.config.files "glance.yml" -}}{{- fail "config.files: glance.yml is reserved" -}}{{- end -}}
{{- $assetSources := 0 -}}
{{- range list .Values.assets.files .Values.assets.existingConfigMap .Values.assets.existingClaim -}}
{{- if . -}}{{- $assetSources = add1 $assetSources -}}{{- end -}}
{{- end -}}
{{- if gt (int $assetSources) 1 -}}{{- fail "assets.files, existingConfigMap and existingClaim are mutually exclusive" -}}{{- end -}}
{{- if and (gt (int $assetSources) 0) (not (index .Values.glance.server "assets-path")) -}}
{{- fail "glance.server.assets-path is required when assets are configured" -}}
{{- end -}}
{{- if and .Values.ingress.enabled (not .Values.ingress.hosts) -}}{{- fail "ingress.hosts is required when ingress is enabled" -}}{{- end -}}
{{- if .Values.podDisruptionBudget.enabled -}}
{{- $min := not (kindIs "invalid" .Values.podDisruptionBudget.minAvailable) -}}
{{- $max := not (kindIs "invalid" .Values.podDisruptionBudget.maxUnavailable) -}}
{{- if eq $min $max -}}{{- fail "podDisruptionBudget requires exactly one of minAvailable and maxUnavailable" -}}{{- end -}}
{{- end -}}
{{- $paths := dict -}}
{{- range .Values.secretFiles -}}
{{- range .items -}}
{{- if hasKey $paths .path -}}{{- fail (printf "secretFiles has duplicate projected path %s" .path) -}}{{- end -}}
{{- $_ := set $paths .path true -}}
{{- end -}}
{{- end -}}
{{- $volumes := dict "config" true "assets" true "secret-files" true "docker-socket" true -}}
{{- range .Values.volumes -}}
{{- if hasKey $volumes .name -}}{{- fail (printf "volumes name %s is reserved or duplicated" .name) -}}{{- end -}}
{{- $_ := set $volumes .name true -}}
{{- end -}}
{{- $mounts := dict "/app/config" true -}}
{{- with index .Values.glance.server "assets-path" -}}
{{- if hasKey $mounts . -}}{{- fail "assets-path conflicts with /app/config" -}}{{- end -}}
{{- $_ := set $mounts . true -}}
{{- end -}}
{{- if .Values.secretFiles -}}
{{- if hasKey $mounts "/run/secrets" -}}{{- fail "assets-path conflicts with /run/secrets" -}}{{- end -}}
{{- $_ := set $mounts "/run/secrets" true -}}
{{- end -}}
{{- if .Values.dockerSocket.enabled -}}
{{- if hasKey $mounts .Values.dockerSocket.mountPath -}}{{- fail "dockerSocket.mountPath conflicts with another mount" -}}{{- end -}}
{{- $_ := set $mounts .Values.dockerSocket.mountPath true -}}
{{- end -}}
{{- range .Values.volumeMounts -}}
{{- if hasKey $mounts .mountPath -}}{{- fail (printf "volumeMounts has duplicate mountPath %s" .mountPath) -}}{{- end -}}
{{- if not (hasKey $volumes .name) -}}{{- fail (printf "volumeMounts references unknown volume %s" .name) -}}{{- end -}}
{{- $_ := set $mounts .mountPath true -}}
{{- end -}}
{{- if hasKey .Values.podAnnotations "checksum/config" -}}{{- fail "podAnnotations.checksum/config is reserved" -}}{{- end -}}
{{- range $labels := list .Values.podLabels .Values.service.labels .Values.configMap.labels -}}
{{- range $key := list "app.kubernetes.io/name" "app.kubernetes.io/instance" "helm.sh/chart" "app.kubernetes.io/version" "app.kubernetes.io/managed-by" -}}
{{- if hasKey $labels $key -}}{{- fail (printf "label %s is reserved" $key) -}}{{- end -}}
{{- end -}}
{{- end -}}
{{- if not (or .Values.config.existingConfigMap .Values.config.existingSecret) -}}
{{- if and .Values.glance.auth.users (not (index .Values.glance.auth "secret-key")) -}}
{{- fail "glance.auth.secret-key is required when users are configured" -}}
{{- end -}}
{{- range .Values.glance.pages -}}
{{- if not (hasKey . "$include") -}}
{{- $full := 0 -}}{{- $includes := false -}}
{{- if kindIs "slice" .columns -}}
{{- range .columns -}}
{{- if hasKey . "$include" -}}{{- $includes = true -}}
{{- else if contains "${" .size -}}{{- $includes = true -}}
{{- else if eq .size "full" -}}{{- $full = add1 $full -}}{{- end -}}
{{- end -}}
{{- if and (not $includes) (or (eq (int $full) 0) (gt (int $full) 2)) -}}
{{- fail "each page must contain one or two full columns" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
