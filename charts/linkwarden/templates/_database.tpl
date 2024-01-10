{{/* 
  Define the Linkwarden database service name (host)
*/}}
{{- define "linkwarden.db.host" -}}
{{- printf "%s-postgresql" .Release.Name }}
{{- end -}}

{{/* 
Create the database URI from the received values
*/}}
{{- define "linkwarden.db.uri" -}}
{{- $dbUser := .Values.linkwarden.database.user | default "linkwarden" }}
{{- $dbPass := .Values.linkwarden.database.password | default "linkwarden" }}
{{- $dbHost := .Values.linkwarden.database.host | default (include "linkwarden.db.host" .)}}
{{- $dbPort := .Values.linkwarden.database.port | default 5432 | int }}
{{- $dbName := .Values.linkwarden.database.name | default "linkwarden" }}
{{- printf "postgresql://%s:%s@%s:%d/%s" $dbUser $dbPass $dbHost $dbPort $dbName }}
{{- end -}}