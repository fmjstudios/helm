{{- define "vaultwarden.ingress.scheme" }}
{{- if gt (len .Values.ingress.tls) 0 -}}
{{- print "https" }}
{{- else -}}
{{- print "http" }}
{{- end -}}
{{- end }}

{{- define "vaultwarden.ingress.url" -}}
{{ printf "%s://%s" (include "vaultwarden.ingress.scheme" .) .Values.vaultwarden.domain }}
{{- end }}
