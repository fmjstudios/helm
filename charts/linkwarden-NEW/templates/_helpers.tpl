{{/*
Expand the name of the chart.
*/}}
{{- define "linkwarden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "linkwarden.fullname" -}}
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
{{- define "linkwarden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "linkwarden.labels" -}}
helm.sh/chart: {{ include "linkwarden.chart" . }}
{{ include "linkwarden.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "linkwarden.selectorLabels" -}}
app.kubernetes.io/name: {{ include "linkwarden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "linkwarden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "linkwarden.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* 
Create the database URI from the received values
*/}}
{{- define "linkwarden.db.uri" -}}
{{- $dbUser := .Values.linkwarden.database.user }}
{{- $dbPass := .Values.linkwarden.database.password }}
{{- $dbHost := .Values.linkwarden.database.host }}
{{- $dbPort := .Values.linkwarden.database.port }}
{{- $dbName := .Values.linkwarden.database.name }}
{{- printf "postgresql://%s:%s@%s:%d/%s" $dbUser $dbPass $dbHost $dbPort $dbName }}
{{- end -}}

{{/*
Set the names of the secrets
*/}}
{{- define "linkwarden.secrets.nextAuth" -}}
{{- printf "%s-nextAuth" (include "linkwarden.fullname" .) }}
{{- end }}

{{- define "linkwarden.secrets.s3" -}}
{{- printf "%s-s3" (include "linkwarden.fullname" .) }}
{{- end }}

{{- define "linkwarden.secrets.db" -}}
{{- printf "%s-db" (include "linkwarden.fullname" .) }}
{{- end }}

{{/* 
  SSO Authentication providers 
*/}}
{{- define "linkwarden.auth.providers" -}}
{{-
  list "42school" "apple" "atlassian" "auth0" "authentik" "battleNet" "box" "bungie" "cognito" "coinbase" "discord" "dropbox" "ids6" "eveOnline" "facebook" "faceit" "foursquare" "freshbooks" "fusionauth" "freshbooks" "github" "gitlab" "google" "hubspot" "isd4" "kakao" "keycloak" "line" "linkedin" "mailchimp" "mailru" "naver" "netlify" "okta" "onelogin" "osso" "osu!" "patreon" "pinterest" "pipedrive" "reddit" "salesforce" "slack" "spotify" "strava" "todoist" "twitch" "unitedEffects" "vk" "wikimedia" "wordpress" "yandex" "zitadel" "zoho" "zoom"
-}}
{{- end }}

{{/* 
  Define reusable environment variables for SSO configuration
*/}}
{{- define "linkwarden.auth.envs.nextPublicEnable" -}}
{{ printf "NEXT_PUBLIC_%s_ENABLED" .provider | upper }}
{{- end }}

{{- define "linkwarden.auth.envs.customName" -}}
{{ printf "%s_CUSTOM_NAME" .provider | upper }}
{{- end }}

{{- define "linkwarden.auth.envs.clientId" -}}
{{ printf "%s_CLIENT_ID" .provider | upper }}
{{- end }}

{{- define "linkwarden.auth.envs.clientSecret" -}}
{{ printf "%s_CLIENT_SECRET" .provider | upper }}
{{- end }}

{{- define "linkwarden.auth.envs.issuer" -}}
{{ printf "%s_ISSUER" .provider | upper }}
{{- end }}

{{/*
  Authentication secret base name - will be suffixed with the configured provider
*/}}
{{- define "linkwarden.auth.secrets.base" -}}
{{- printf "%s-auth" (include "linkwarden.fullname" .) }}
{{- end }}

{{/*
Define the PV name
*/}}
{{- define "linkwarden.pv.name" -}}
{{- printf "%s-pv" (include "linkwarden.fullname" .)}}
{{- end -}}

{{/*
Define the PVC name
*/}}
{{- define "linkwarden.pvc.name" -}}
{{- printf "%s-pvc" (include "linkwarden.fullname" .)}}
{{- end -}}

{{/* 
Obtain the API version for the Pod Disruption Budget
*/}}
{{- define "linkwarden.pdb.apiVersion" -}}
{{- if and (.Capabilities.ApiVersions.Has "policy/v1") (semverCompare ">= 1.21-0" .Capabilities.KubeVersion.Version) -}}
{{- print "policy/v1" }}
{{- else -}}
{{- print "policy/v1beta1" }}  
{{- end -}}
{{- end -}}


{{/* 
Determine which Kubernetes resource to create: StatefulSet or Deployment
*/}}
{{- define "linkwarden.resourceType" -}}
{{- if eq .Values.linkwarden.database.type "sqlite" }}
{{- "StatefulSet" }}
{{- else }}
{{- "Deployment" }}
{{- end }}
{{- end }}