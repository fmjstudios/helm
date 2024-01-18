{{/*
Define the absolute data path
*/}}
{{- define "paperless.paths.base" -}}
{{- printf "/usr/src/paperless/%s" .path }}
{{- end -}}