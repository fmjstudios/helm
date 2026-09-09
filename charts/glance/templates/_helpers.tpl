{{/*
Expand the name of the chart.
*/}}
{{- define "glance.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "glance.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "glance.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "glance.labels" -}}
helm.sh/chart: {{ include "glance.chart" . }}
{{ include "glance.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "glance.selectorLabels" -}}
app.kubernetes.io/name: {{ include "glance.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "glance.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "glance.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* Suffix before truncation to prevent collisions with the base name. */}}
{{- define "glance.assetsName" -}}
{{- printf "%s-assets" (include "glance.fullname" . | trunc 56 | trimSuffix "-") -}}
{{- end -}}
{{- define "glance.image" -}}
{{- $repository := printf "%s/%s" .Values.image.registry .Values.image.repository -}}
{{- if .Values.image.digest -}}
{{- printf "%s@%s" $repository .Values.image.digest -}}
{{- else -}}
{{- printf "%s:%s" $repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}
{{- define "glance.configuration" -}}
{{- $config := deepCopy .Values.glance -}}
{{- if not $config.auth.users -}}{{- $_ := unset $config "auth" -}}{{- end -}}
{{- range $key, $value := $config.theme -}}
{{- if kindIs "invalid" $value -}}{{- $_ := unset $config.theme $key -}}{{- end -}}
{{- end -}}
{{- range $preset := $config.theme.presets -}}
{{- range $key, $value := $preset -}}
{{- if kindIs "invalid" $value -}}{{- $_ := unset $preset $key -}}{{- end -}}
{{- end -}}
{{- end -}}
{{- toYaml $config -}}
{{- end -}}
