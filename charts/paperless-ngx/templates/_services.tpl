{{- /*
  Define the hostnames to the various services
*/}}
{{- define "paperless.paths.postgresql" -}}
{{- printf "%s-postgresql" .Release.Name }}
{{- end -}}

{{- define "paperless.paths.redis" -}}
{{- printf "%s-redis" .Release.Name }}
{{- end -}}

{{- define "paperless.paths.tika" -}}
{{- printf "%s-tika" .Release.Name }}
{{- end -}}

{{- define "paperless.paths.gotenberg" -}}
{{- printf "%s-gotenberg" .Release.Name }}
{{- end -}}
