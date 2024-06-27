{{/*
Expand the name of the chart.
*/}}
{{- define "gobackup.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gobackup.fullname" -}}
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
{{- define "gobackup.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gobackup.labels" -}}
helm.sh/chart: {{ include "gobackup.chart" . }}
{{ include "gobackup.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gobackup.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gobackup.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gobackup.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gobackup.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define Secret names
*/}}
{{- define "gobackup.secret.webAuth" }}
{{- printf "%s-web-credentials" (include "gobackup.fullname" .) }}
{{- end }}

{{- define "gobackup.secret.database" }}
{{- printf "%s-database-%s-%s-credentials" (include "gobackup.fullname" .) .model .type }}
{{- end }}

{{- define "gobackup.secret.storage" }}
{{- printf "%s-storage-%s-%s-credentials" (include "gobackup.fullname" .) .model .type }}
{{- end }}

{{- define "gobackup.secret.notifier" }}
{{- printf "%s-notifier-%s-%s-credentials" (include "gobackup.fullname" .) .model .type }}
{{- end }}

{{- define "gobackup.secret.encryption.password" }}
{{- printf "%s-%s-openssl-passphrase" (include "gobackup.fullname" .) .model }}
{{- end }}

{{/*
Define env variable names
*/}}
{{- define "gobackup.env.username" }}
{{- printf "%s_%s_USERNAME" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.password" }}
{{- printf "%s_%s_PASSWORD" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.privateKey" }}
{{- printf "%s_%s_PRIVATE_KEY" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.passphrase" }}
{{- printf "%s_%s_PASSPHRASE" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.accessKey" }}
{{- printf "%s_%s_SECRET_ACCESS_KEY" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.secretKey" }}
{{- printf "%s_%s_SECRET_KEY" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.credentials" }}
{{- printf "%s_%s_CREDENTIALS" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.clientId" }}
{{- printf "%s_%s_CLIENT_ID" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.clientSecret" }}
{{- printf "%s_%s_CLIENT_SECRET" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.token" }}
{{- printf "%s_%s_TOKEN" .model .type | upper }}
{{- end }}

{{- define "gobackup.env.encryption.password" }}
{{- printf "%s_OPENSSL_ENCRYPTION_PASSPHRASE" .model | upper }}
{{- end }}

{{/*
Obtain the API version for the Pod Disruption Budget
*/}}
{{- define "gobackup.pdb.apiVersion" -}}
{{- if and (.Capabilities.APIVersions.Has "policy/v1") (semverCompare ">= 1.21-0" .Capabilities.KubeVersion.Version) -}}
{{- print "policy/v1" }}
{{- else -}}
{{- print "policy/v1beta1" }}
{{- end -}}
{{- end -}}
