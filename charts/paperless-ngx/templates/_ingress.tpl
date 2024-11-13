{{- define "paperless.ingress.scheme" }}
{{- if gt (len .Values.ingress.tls) 0 -}}
{{- print "https" }}
{{- else -}}
{{- print "http" }}
{{- end -}}
{{- end }}

{{- define "paperless.ingress.url" -}}
{{ printf "%s://%s" (include "paperless.ingress.scheme" .) .Values.paperless.domain }}
{{- end }}
