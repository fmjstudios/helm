{{/*
Set the names of the secrets
*/}}
{{- define "paperless.secrets.general" -}}
{{- printf "%s-general" (include "paperless.fullname" .) }}
{{- end }}

{{- define "paperless.secrets.admin" -}}
{{- printf "%s-admin" (include "paperless.fullname" .) }}
{{- end }}

{{- define "paperless.secrets.postgresql" -}}
{{- printf "%s-postgresql-auth" (include "paperless.fullname" .) }}
{{- end }}

{{- define "paperless.secrets.redis" -}}
{{- printf "%s-redis-auth" (include "paperless.fullname" .) }}
{{- end }}

{{- define "paperless.secrets.smtp" -}}
{{- printf "%s-smtp-auth" (include "paperless.fullname" .) }}
{{- end }}

{{/*
Build connection URI's
*/}}
{{- define "paperless.redis.uri" -}}
{{- printf "redis://:%s@%s" .Values.paperless.redis.password .Values.paperless.redis.host  }}
{{- end }}

{{/*
  Detect or generate a secret key for the installation
*/}}
{{- define "paperless.secretkey" -}}
{{- if .Values.paperless.secretKey.value }}
{{- printf "%s" .Values.paperless.secretKey.value }}
{{ else }}
{{- $secretKey := randAlphaNum 32 -}}
{{- printf "%s" $secretKey }}
{{- end }}