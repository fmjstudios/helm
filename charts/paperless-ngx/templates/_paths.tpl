{{- /*
Define the PV name
*/}}
{{- define "paperless.pv.data.name" -}}
{{- printf "%s-data-pv" (include "paperless.fullname" .) }}
{{- end -}}

{{- define "paperless.pv.media.name" -}}
{{- printf "%s-media-pv" (include "paperless.fullname" .) }}
{{- end -}}

{{- /*
Define the PVC name
*/}}
{{- define "paperless.pvc.data.name" -}}
{{- printf "%s-data-pvc" (include "paperless.fullname" .) }}
{{- end -}}

{{- define "paperless.pvc.media.name" -}}
{{- printf "%s-media-pvc" (include "paperless.fullname" .) }}
{{- end -}}


{{- /*
Define the absolute data path
*/}}
{{- define "paperless.paths.base" -}}
{{- printf "/usr/src/paperless/%s" .path }}
{{- end -}}
