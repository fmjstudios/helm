{{/*
  Database templates
*/}}
{{- define "gobackup.env.db.user" }}
{{- printf "%s_%s_DB_USERNAME" .name .type | upper }}
{{- end }}
