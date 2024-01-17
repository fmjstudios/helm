{{/*
Expand the name of the chart.
*/}}
{{- define "uptimeKuma.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "uptimeKuma.fullname" -}}
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
{{- define "uptimeKuma.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "uptimeKuma.labels" -}}
helm.sh/chart: {{ include "uptimeKuma.chart" . }}
{{ include "uptimeKuma.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "uptimeKuma.selectorLabels" -}}
app.kubernetes.io/name: {{ include "uptimeKuma.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "uptimeKuma.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "uptimeKuma.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Set the names of the secrets
*/}}
{{- define "uptimeKuma.secrets.tls-passphrase" -}}
{{- printf "%s-tls" (include "uptimeKuma.fullname" .) }}
{{- end }}

{{- define "uptimeKuma.secrets.cloudflared-token" -}}
{{- printf "%s-cf-tunnel-token" (include "uptimeKuma.fullname" .) }}
{{- end }}

{{/*
Define the PV name
*/}}
{{- define "uptimeKuma.pv.name" -}}
{{- printf "%s-pv" (include "uptimeKuma.fullname" .)}}
{{- end -}}

{{/*
Define the PVC name
*/}}
{{- define "uptimeKuma.pvc.name" -}}
{{- printf "%s-pvc" (include "uptimeKuma.fullname" .)}}
{{- end -}}

{{/* 
Obtain the API version for the Pod Disruption Budget
*/}}
{{- define "uptimeKuma.pdb.apiVersion" -}}
{{- if and (.Capabilities.APIVersions.Has "policy/v1") (semverCompare ">= 1.21-0" .Capabilities.KubeVersion.Version) -}}
{{- print "policy/v1" }}
{{- else -}}
{{- print "policy/v1beta1" }}  
{{- end -}}
{{- end -}}


{{/*
Define the absolute data path
*/}}
{{- define "uptimeKuma.paths.data" -}}
{{- printf "/app/%s" .Values.uptimeKuma.data.path }}
{{- end -}}