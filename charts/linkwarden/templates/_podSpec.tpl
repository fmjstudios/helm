{{/*
  Define the Kubernetes pod spec to be reused within the Deployment/StatefulSet.
*/}}
{{- define "linkwarden.podSpec" -}}
serviceName: {{ include "linkwarden.fullname" . }}
replicas: 1
selector:
  matchLabels:
    {{- include "linkwarden.selectorLabels" . | nindent 6 }}
{{- if .Values.strategy -}}
updateStrategy:
{{- toYaml .Values.strategy | nindent 4 }}
{{- end }}
template:
  metadata:
    {{- if .Values.podAnnotations }}
    annotations:
      checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
      checksum/secrets: {{ include (print $.Template.BasePath "/secrets.yaml") . | sha256sum }}
      {{- toYaml .Values.podAnnotations | nindent 8 }}
    {{- end }}
    labels:
      {{- include "linkwarden.selectorLabels" . | nindent 8 }}
    {{- if .Values.podLabels -}}
      {{- toYaml .Values.podLabels | nindent 8 }}
    {{- end }}
  spec:
    {{- if .Values.image.pullSecrets }}
    imagePullSecrets:
      {{- toYaml .Values.image.pullSecrets | nindent 8 }}
    {{- end }}
    serviceAccountName: {{ include "linkwarden.serviceAccountName" . }}
    containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        envFrom:
          - configMapRef:
              name: {{ include "linkwarden.fullname" . }}
        env:
          {{- if or .Values.linkwarden.nextAuthSecret.value .Values.linkwarden.nextAuthSecret.existingSecret.name }}
          - name: NEXTAUTH_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.nextAuthSecret.existingSecret.name | default (include "linkwarden.secrets.nextAuth" .) }}
                key: {{ .Values.linkwarden.nextAuthSecret.existingSecret.key | default "token" }}
          {{- end }}
          {{- if or .Values.linkwarden.data.s3.accessKey.value .Values.linkwarden.data.s3.accessKey.existingSecret.name }}
          - name: SPACES_KEY
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.data.s3.accessKey.existingSecret.name | default (include "linkwarden.secrets.s3" .) }}
                key: {{ .Values.linkwarden.data.s3.accessKey.existingSecret.key | default "accessKey" }}
          {{- end }}
          {{- if or .Values.linkwarden.data.s3.secretKey.value .Values.linkwarden.data.s3.secretKey.existingSecret.name }}
          - name: SPACES_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.data.s3.secretKey.existingSecret.name | default (include "linkwarden.secrets.s3" .) }}
                key: {{ .Values.linkwarden.data.s3.secretKey.existingSecret.key | default "secretKey" }}
          {{- end }}
          {{- if or (include "linkwarden.db.uri" .) .Values.linkwarden.database.existingSecret.name }}
          - name: DATABASE_URL
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.database.existingSecret.name | default (include "linkwarden.secrets.db" .) }}
                key: {{ .Values.linkwarden.database.existingSecret.key | default "uri" }}
          {{- end }}
          {{/* Authentication settings */}}
          {{- if .Values.linkwarden.auth.sso.42school.enabled }}
          - name: NEXT_PUBLIC_FORTYTWO_ENABLED
            value: {{ .Values.linkwarden.auth.sso.42school.enabled }}
          - name: FORTYTWO_CUSTOM_NAME
            value: {{ .Values.linkwarden.auth.sso.42school.customName }}
          - name: FORTYTWO_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.42school.existingSecret | default (include "linkwarden.secrets.auth.42school" .) }}
                key: "clientId"
          - name: FORTYTWO_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.42school.existingSecret | default (include "linkwarden.secrets.auth.42school" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{- if .Values.linkwarden.auth.sso.apple.enabled }}
          - name: NEXT_PUBLIC_APPLE_ENABLED
            value: {{ .Values.linkwarden.auth.sso.apple.enabled }}
          - name: APPLE_CUSTOM_NAME
            value: {{ .Values.linkwarden.auth.sso.apple.customName }}
          - name: APPLE_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.apple.existingSecret | default (include "linkwarden.secrets.auth.apple" .) }}
                key: "clientId"
          - name: APPLE_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.apple.existingSecret | default (include "linkwarden.secrets.auth.apple" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{- if .Values.linkwarden.auth.sso.atlassian.enabled }}
          - name: NEXT_PUBLIC_ATLASSIAN_ENABLED
            value: {{ .Values.linkwarden.auth.sso.atlassian.enabled }}
          - name: APPLE_CUSTOM_NAME
            value: {{ .Values.linkwarden.auth.sso.atlassian.customName }}
          - name: APPLE_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.atlassian.existingSecret | default (include "linkwarden.secrets.auth.atlassian" .) }}
                key: "clientId"
          - name: APPLE_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.atlassian.existingSecret | default (include "linkwarden.secrets.auth.atlassian" .) }}
                key: "clientSecret"                        
          {{- end }}

    #     ports:
    #       - name: http
    #         containerPort: {{ .Values.linkwarden.rocket.port }}
    #         protocol: TCP
    #       {{- if .Values.linkwarden.websocket.enabled }}
    #       - name: websocket
    #         containerPort: {{ .Values.linkwarden.websocket.port }}
    #         protocol: TCP
    #       {{- end }}
    #     volumeMounts:
    #       - name: {{ include "linkwarden.pv.name" . }}
    #         mountPath: {{ .Values.linkwarden.data.rootPath | default "/data" }}
    #     {{- if .Values.resources }}
    #     resources:
    #       {{- toYaml .Values.resources | nindent 12 }}
    #     {{- end }}
    #     {{- if .Values.securityContext }}
    #     securityContext:
    #       {{- toYaml .Values.securityContext | nindent 12 }}
    #     {{- end }}
    #     {{- if .Values.livenessProbe.enabled }}
    #     livenessProbe:
    #       httpGet:
    #         path: /alive
    #         port: http
    #       initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds }}
    #       periodSeconds: {{ .Values.livenessProbe.periodSeconds }}
    #       timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds }}
    #       successThreshold: {{ .Values.livenessProbe.successThreshold }}
    #       failureThreshold: {{ .Values.livenessProbe.failureThreshold }}
    #     {{- end }}
    #     {{- if .Values.readinessProbe.enabled }}
    #     livenessProbe:
    #       httpGet:
    #         path: /alive
    #         port: http
    #       initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds }}
    #       periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
    #       timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
    #       successThreshold: {{ .Values.readinessProbe.successThreshold }}
    #       failureThreshold: {{ .Values.readinessProbe.failureThreshold }}
    #     {{- end }}
    #     {{- if .Values.startupProbe.enabled }}
    #     livenessProbe:
    #       httpGet:
    #         path: /alive
    #         port: http
    #       initialDelaySeconds: {{ .Values.startupProbe.initialDelaySeconds }}
    #       periodSeconds: {{ .Values.startupProbe.periodSeconds }}
    #       timeoutSeconds: {{ .Values.startupProbe.timeoutSeconds }}
    #       successThreshold: {{ .Values.startupProbe.successThreshold }}
    #       failureThreshold: {{ .Values.startupProbe.failureThreshold }}
    #     {{- end }}
    # volumes:
    #   - name: {{ include "linkwarden.pv.name" . }}
    #     persistentVolumeClaim:
    #       claimName: {{ include "linkwarden.pvc.name" . }}
    # {{- if .Values.nodeSelector }}
    # nodeSelector:
    #   {{- toYaml .Values.nodeSelector | nindent 8 }}
    # {{- end }}
    # {{- if .Values.affinity }}
    # affinity:
    #   {{- toYaml .Values.affinity | nindent 8 }}
    # {{- end }}
    # {{- if .Values.tolerations }}
    # tolerations:
    #   {{- toYaml .Values.tolerations | nindent 8 }}
    # {{- end }}
    # {{- if .Values.podSecurityContext }}
    # securityContext:
    #   {{- toYaml .Values.podSecurityContext | nindent 8 }}
    # {{- end }}
    # {{- if .Values.initContainers }}
    # initContainers:
    #   {{- toYaml .Values.initContainers | nindent 8 }}
    # {{- end }}
{{- end }}