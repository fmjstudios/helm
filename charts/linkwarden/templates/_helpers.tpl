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
{{/* Authentication secrets */}}
{{- define "linkwarden.secrets.auth.42school" -}}
{{- printf "%s-auth-42school" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.apple" -}}
{{- printf "%s-auth-apple" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.atlassian" -}}
{{- printf "%s-auth-atlassian" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.auth0" -}}
{{- printf "%s-auth-auth0" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.authentik" -}}
{{- printf "%s-auth-authentik" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.battleNet" -}}
{{- printf "%s-auth-battleNet" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.box" -}}
{{- printf "%s-auth-box" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.bungie" -}}
{{- printf "%s-auth-bungie" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.cognito" -}}
{{- printf "%s-auth-cognito" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.coinbase" -}}
{{- printf "%s-auth-coinbase" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.discord" -}}
{{- printf "%s-auth-discord" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.dropbox" -}}
{{- printf "%s-auth-dropbox" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.duende6" -}}
{{- printf "%s-auth-duende6" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.eve" -}}
{{- printf "%s-auth-eve" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.facebook" -}}
{{- printf "%s-auth-facebook" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.faceit" -}}
{{- printf "%s-auth-faceit" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.freshbooks" -}}
{{- printf "%s-auth-freshbooks" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.foursquare" -}}
{{- printf "%s-auth-foursquare" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.fusionauth" -}}
{{- printf "%s-auth-fusionauth" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.github" -}}
{{- printf "%s-auth-github" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.gitlab" -}}
{{- printf "%s-auth-gitlab" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.google" -}}
{{- printf "%s-auth-google" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.hubspot" -}}
{{- printf "%s-auth-hubspot" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.duende4" -}}
{{- printf "%s-auth-duende4" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.kakao" -}}
{{- printf "%s-auth-kakao" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.keycloak" -}}
{{- printf "%s-auth-keycloak" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.line" -}}
{{- printf "%s-auth-line" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.linkedIn" -}}
{{- printf "%s-auth-linkedIn" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.mailchimp" -}}
{{- printf "%s-auth-mailchimp" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.mailru" -}}
{{- printf "%s-auth-mailru" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.keycloak" -}}
{{- printf "%s-auth-keycloak" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.naver" -}}
{{- printf "%s-auth-naver" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.netlify" -}}
{{- printf "%s-auth-netlify" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.okta" -}}
{{- printf "%s-auth-okta" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.onelogin" -}}
{{- printf "%s-auth-onelogin" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.osso" -}}
{{- printf "%s-auth-osso" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.osu" -}}
{{- printf "%s-auth-osu" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.patreon" -}}
{{- printf "%s-auth-patreon" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.pinterest" -}}
{{- printf "%s-auth-pinterest" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.pipedrive" -}}
{{- printf "%s-auth-pipedrive" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.reddit" -}}
{{- printf "%s-auth-reddit" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.salesforce" -}}
{{- printf "%s-auth-salesforce" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.slack" -}}
{{- printf "%s-auth-slack" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.spotify" -}}
{{- printf "%s-auth-spotify" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.strava" -}}
{{- printf "%s-auth-strava" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.todoist" -}}
{{- printf "%s-auth-todoist" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.twitch" -}}
{{- printf "%s-auth-twitch" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.unitedEffects" -}}
{{- printf "%s-auth-unitedEffects" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.vk" -}}
{{- printf "%s-auth-vk" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.wikimedia" -}}
{{- printf "%s-auth-wikimedia" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.wordpress" -}}
{{- printf "%s-auth-wordpress" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.yandex" -}}
{{- printf "%s-auth-yandex" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.zitadel" -}}
{{- printf "%s-auth-zitadel" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.zoho" -}}
{{- printf "%s-auth-zoho" (include "linkwarden.fullname" .) }}
{{- end }}
{{- define "linkwarden.secrets.auth.zoom" -}}
{{- printf "%s-auth-zoom" (include "linkwarden.fullname" .) }}
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