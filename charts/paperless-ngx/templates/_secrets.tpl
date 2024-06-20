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
{{- define "paperless.redis.password" -}}
{{- printf "%s" default .Values.paperless.redis.password (lookup "v1" "Secret" .Release.Namespace (.Values.paperless.redis.existingSecret)).data.password | b64dec }}
{{- end }}

{{- define "paperless.redis.uri" -}}
{{- printf "redis://%s:%s@%s:%d" .Values.paperless.redis.username (include "paperless.redis.password" .) .Values.paperless.redis.host .Values.paperless.redis.port }}
{{- end }}

{{/*
  Detect or generate a secret key for the installation
*/}}
{{- define "paperless.secretkey" -}}
{{- if .Values.paperless.secretKey.value }}
{{- printf "%s" .Values.paperless.secretKey.value }}
{{ else }}
{{- randAlphaNum 32 -}}
{{- end }}
{{- end }}