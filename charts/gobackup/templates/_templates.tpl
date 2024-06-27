{{/*
  Database templates
*/}}
{{- define "gobackup.template.databases" -}}
{{ .name }}:
  type: {{- .type }}
  {{- toYaml .config | nindent 2 }}
  {{- if not .existingSecret }}
  username: {{ default (include "gobackup.secret.db" (dict "type" .type)) (.username | quote) }}
  password: {{ .password | quote }}
  {{- end }}
{{- end }}

{{/*
  Storage templates
*/}}
{{- define "gobackup.template.storage.ftp" -}}
{{ .name }}:
  type: {{- .type }}
  {{ toYaml .config | nindent 2 }}
  {{- if not .existingSecret }}
  username: {{ .username | quote }}
  password: {{ .password | quote }}
  {{- end }}
{{- end }}
