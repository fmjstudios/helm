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
          {{-/* 42 School */}}
          {{- if .Values.linkwarden.auth.sso.42school.enabled }}
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
          {{-/* Apple */}}
          {{- if .Values.linkwarden.auth.sso.apple.enabled }}
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
          {{-/* Atlassian */}}
          {{- if .Values.linkwarden.auth.sso.atlassian.enabled }}
          - name: ATLASSIAN_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.atlassian.existingSecret | default (include "linkwarden.secrets.auth.atlassian" .) }}
                key: "clientId"
          - name: ATLASSIAN_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.atlassian.existingSecret | default (include "linkwarden.secrets.auth.atlassian" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Auth0 */}}
          {{- if .Values.linkwarden.auth.sso.auth0.enabled }}
          - name: AUTH0_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.auth0.existingSecret | default (include "linkwarden.secrets.auth.auth0" .) }}
                key: "clientId"
          - name: AUTH0_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.auth0.existingSecret | default (include "linkwarden.secrets.auth.auth0" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Authentik */}}
          {{- if .Values.linkwarden.auth.sso.authentik.enabled }}
          - name: AUTHENTIK_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.authentik.existingSecret | default (include "linkwarden.secrets.auth.authentik" .) }}
                key: "clientId"
          - name: AUTHENTIK_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.authentik.existingSecret | default (include "linkwarden.secrets.auth.authentik" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Battle.net */}}
          {{- if .Values.linkwarden.auth.sso.battleNet.enabled }}
          - name: BATTLENET_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.battleNet.existingSecret | default (include "linkwarden.secrets.auth.battleNet" .) }}
                key: "clientId"
          - name: BATTLENET_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.battleNet.existingSecret | default (include "linkwarden.secrets.auth.battleNet" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Box */}}
          {{- if .Values.linkwarden.auth.sso.box.enabled }}
          - name: BOX_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.box.existingSecret | default (include "linkwarden.secrets.auth.box" .) }}
                key: "clientId"
          - name: BOX_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.box.existingSecret | default (include "linkwarden.secrets.auth.box" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Bungie */}}
          {{- if .Values.linkwarden.auth.sso.bungie.enabled }}
          - name: BUNGIE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.bungie.existingSecret | default (include "linkwarden.secrets.auth.bungie" .) }}
                key: "clientId"
          - name: BUNGIE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.bungie.existingSecret | default (include "linkwarden.secrets.auth.bungie" .) }}
                key: "clientSecret"
          - name: BUNGIE_API_KEY
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.bungie.existingSecret | default (include "linkwarden.secrets.auth.bungie" .) }}
                key: "apiKey"                 
          {{- end }}
          {{-/* Cognito */}}
          {{- if .Values.linkwarden.auth.sso.cognito.enabled }}
          - name: COGNITO_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.cognito.existingSecret | default (include "linkwarden.secrets.auth.cognito" .) }}
                key: "clientId"
          - name: COGNITO_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.cognito.existingSecret | default (include "linkwarden.secrets.auth.cognito" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Coinbase */}}
          {{- if .Values.linkwarden.auth.sso.coinbase.enabled }}
          - name: COINBASE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.coinbase.existingSecret | default (include "linkwarden.secrets.auth.coinbase" .) }}
                key: "clientId"
          - name: COINBASE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.coinbase.existingSecret | default (include "linkwarden.secrets.auth.coinbase" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Discord */}}
          {{- if .Values.linkwarden.auth.sso.discord.enabled }}
          - name: DISCORD_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.discord.existingSecret | default (include "linkwarden.secrets.auth.discord" .) }}
                key: "clientId"
          - name: DISCORD_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.discord.existingSecret | default (include "linkwarden.secrets.auth.discord" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Dropbox */}}
          {{- if .Values.linkwarden.auth.sso.dropbox.enabled }}
          - name: DROPBOX_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.dropbox.existingSecret | default (include "linkwarden.secrets.auth.dropbox" .) }}
                key: "clientId"
          - name: DROPBOX_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.dropbox.existingSecret | default (include "linkwarden.secrets.auth.dropbox" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Duende IdentityServer6 */}}
          {{- if .Values.linkwarden.auth.sso.duende6.enabled }}
          - name: DUENDE_IDS6_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.duende6.existingSecret | default (include "linkwarden.secrets.auth.duende6" .) }}
                key: "clientId"
          - name: DUENDE_IDS6_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.duende6.existingSecret | default (include "linkwarden.secrets.auth.duende6" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* EVE Online */}}
          {{- if .Values.linkwarden.auth.sso.eve.enabled }}
          - name: EVEONLINE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.eve.existingSecret | default (include "linkwarden.secrets.auth.eve" .) }}
                key: "clientId"
          - name: EVEONLINE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.eve.existingSecret | default (include "linkwarden.secrets.auth.eve" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Facebook */}}
          {{- if .Values.linkwarden.auth.sso.facebook.enabled }}
          - name: FACEBOOK_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.facebook.existingSecret | default (include "linkwarden.secrets.auth.facebook" .) }}
                key: "clientId"
          - name: FACEBOOK_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.facebook.existingSecret | default (include "linkwarden.secrets.auth.facebook" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* FACEIT */}}
          {{- if .Values.linkwarden.auth.sso.faceit.enabled }}
          - name: FACEIT_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.faceit.existingSecret | default (include "linkwarden.secrets.auth.faceit" .) }}
                key: "clientId"
          - name: FACEIT_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.faceit.existingSecret | default (include "linkwarden.secrets.auth.faceit" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Foursqaure */}}
          {{- if .Values.linkwarden.auth.sso.foursquare.enabled }}
          - name: FOURSQUARE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.foursquare.existingSecret | default (include "linkwarden.secrets.auth.foursquare" .) }}
                key: "clientId"
          - name: FOURSQUARE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.foursquare.existingSecret | default (include "linkwarden.secrets.auth.foursquare" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Freshbooks */}}
          {{- if .Values.linkwarden.auth.sso.freshbooks.enabled }}
          - name: FRESHBOOKS_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.freshbooks.existingSecret | default (include "linkwarden.secrets.auth.freshbooks" .) }}
                key: "clientId"
          - name: FRESHBOOKS_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.freshbooks.existingSecret | default (include "linkwarden.secrets.auth.freshbooks" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* FusionAuth */}}
          {{- if .Values.linkwarden.auth.sso.fusionauth.enabled }}
          - name: FRESHBOOKS_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.fusionauth.existingSecret | default (include "linkwarden.secrets.auth.fusionauth" .) }}
                key: "clientId"
          - name: FRESHBOOKS_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.fusionauth.existingSecret | default (include "linkwarden.secrets.auth.fusionauth" .) }}
                key: "clientSecret"        
          - name: FUSIONAUTH_TENANT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.fusionauth.existingSecret | default (include "linkwarden.secrets.auth.fusionauth" .) }}
                key: "tenantId"                                 
          {{- end }}
          {{-/* GitHub */}}
          {{- if .Values.linkwarden.auth.sso.github.enabled }}
          - name: GITHUB_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.github.existingSecret | default (include "linkwarden.secrets.auth.github" .) }}
                key: "clientId"
          - name: GITHUB_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.github.existingSecret | default (include "linkwarden.secrets.auth.github" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* GitLab */}}
          {{- if .Values.linkwarden.auth.sso.gitlab.enabled }}
          - name: GITLAB_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.gitlab.existingSecret | default (include "linkwarden.secrets.auth.gitlab" .) }}
                key: "clientId"
          - name: GITLAB_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.gitlab.existingSecret | default (include "linkwarden.secrets.auth.gitlab" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Google */}}
          {{- if .Values.linkwarden.auth.sso.google.enabled }}
          - name: GOOGLE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.google.existingSecret | default (include "linkwarden.secrets.auth.google" .) }}
                key: "clientId"
          - name: GOOGLE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.google.existingSecret | default (include "linkwarden.secrets.auth.google" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* HubSpot */}}
          {{- if .Values.linkwarden.auth.sso.hubspot.enabled }}
          - name: HUBSPOT_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.hubspot.existingSecret | default (include "linkwarden.secrets.auth.hubspot" .) }}
                key: "clientId"
          - name: HUBSPOT_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.hubspot.existingSecret | default (include "linkwarden.secrets.auth.hubspot" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Duende IdentityServer4 */}}
          {{- if .Values.linkwarden.auth.sso.duende4.enabled }}
          - name: IDS4_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.duende4.existingSecret | default (include "linkwarden.secrets.auth.duende4" .) }}
                key: "clientId"
          - name: IDS4_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.duende4.existingSecret | default (include "linkwarden.secrets.auth.duende4" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Kakao */}}
          {{- if .Values.linkwarden.auth.sso.kakao.enabled }}
          - name: KAKAO_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.kakao.existingSecret | default (include "linkwarden.secrets.auth.kakao" .) }}
                key: "clientId"
          - name: KAKAO_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.kakao.existingSecret | default (include "linkwarden.secrets.auth.kakao" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Keycloak */}}
          {{- if .Values.linkwarden.auth.sso.keycloak.enabled }}
          - name: KEYCLOAK_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.keycloak.existingSecret | default (include "linkwarden.secrets.auth.keycloak" .) }}
                key: "clientId"
          - name: KEYCLOAK_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.keycloak.existingSecret | default (include "linkwarden.secrets.auth.keycloak" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* LINE */}}
          {{- if .Values.linkwarden.auth.sso.line.enabled }}
          - name: LINE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.line.existingSecret | default (include "linkwarden.secrets.auth.line" .) }}
                key: "clientId"
          - name: LINE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.line.existingSecret | default (include "linkwarden.secrets.auth.line" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* LinkedIn */}}
          {{- if .Values.linkwarden.auth.sso.linkedIn.enabled }}
          - name: LINKEDIN_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.linkedIn.existingSecret | default (include "linkwarden.secrets.auth.linkedIn" .) }}
                key: "clientId"
          - name: LINKEDIN_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.linkedIn.existingSecret | default (include "linkwarden.secrets.auth.linkedIn" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Mailchimp */}}
          {{- if .Values.linkwarden.auth.sso.mailchimp.enabled }}
          - name: MAILCHIMP_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.mailchimp.existingSecret | default (include "linkwarden.secrets.auth.mailchimp" .) }}
                key: "clientId"
          - name: MAILCHIMP_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.mailchimp.existingSecret | default (include "linkwarden.secrets.auth.mailchimp" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Mail.ru */}}
          {{- if .Values.linkwarden.auth.sso.mailru.enabled }}
          - name: MAILRU_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.mailru.existingSecret | default (include "linkwarden.secrets.auth.mailru" .) }}
                key: "clientId"
          - name: MAILRU_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.mailru.existingSecret | default (include "linkwarden.secrets.auth.mailru" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Naver */}}
          {{- if .Values.linkwarden.auth.sso.naver.enabled }}
          - name: NAVER_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.naver.existingSecret | default (include "linkwarden.secrets.auth.naver" .) }}
                key: "clientId"
          - name: NAVER_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.naver.existingSecret | default (include "linkwarden.secrets.auth.naver" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Netlify */}}
          {{- if .Values.linkwarden.auth.sso.netlify.enabled }}
          - name: NETLIFY_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.netlify.existingSecret | default (include "linkwarden.secrets.auth.netlify" .) }}
                key: "clientId"
          - name: NETLIFY_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.netlify.existingSecret | default (include "linkwarden.secrets.auth.netlify" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Okta */}}
          {{- if .Values.linkwarden.auth.sso.okta.enabled }}
          - name: OKTA_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.okta.existingSecret | default (include "linkwarden.secrets.auth.okta" .) }}
                key: "clientId"
          - name: OKTA_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.okta.existingSecret | default (include "linkwarden.secrets.auth.okta" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* OneLogin */}}
          {{- if .Values.linkwarden.auth.sso.onelogin.enabled }}
          - name: ONELOGIN_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.onelogin.existingSecret | default (include "linkwarden.secrets.auth.onelogin" .) }}
                key: "clientId"
          - name: ONELOGIN_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.onelogin.existingSecret | default (include "linkwarden.secrets.auth.onelogin" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Osso */}}
          {{- if .Values.linkwarden.auth.sso.osso.enabled }}
          - name: OSSO_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.osso.existingSecret | default (include "linkwarden.secrets.auth.osso" .) }}
                key: "clientId"
          - name: OSSO_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.osso.existingSecret | default (include "linkwarden.secrets.auth.osso" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* osu! */}}
          {{- if .Values.linkwarden.auth.sso.osu.enabled }}
          - name: OSU_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.osu.existingSecret | default (include "linkwarden.secrets.auth.osu" .) }}
                key: "clientId"
          - name: OSU_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.osu.existingSecret | default (include "linkwarden.secrets.auth.osu" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Patreon */}}
          {{- if .Values.linkwarden.auth.sso.patreon.enabled }}
          - name: PATREON_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.patreon.existingSecret | default (include "linkwarden.secrets.auth.patreon" .) }}
                key: "clientId"
          - name: PATREON_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.patreon.existingSecret | default (include "linkwarden.secrets.auth.patreon" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Pinterest */}}
          {{- if .Values.linkwarden.auth.sso.pinterest.enabled }}
          - name: PINTEREST_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.pinterest.existingSecret | default (include "linkwarden.secrets.auth.pinterest" .) }}
                key: "clientId"
          - name: PINTEREST_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.pinterest.existingSecret | default (include "linkwarden.secrets.auth.pinterest" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* PipeDrive */}}
          {{- if .Values.linkwarden.auth.sso.pipedrive.enabled }}
          - name: PIPEDRIVE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.pipedrive.existingSecret | default (include "linkwarden.secrets.auth.pipedrive" .) }}
                key: "clientId"
          - name: PIPEDRIVE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.pipedrive.existingSecret | default (include "linkwarden.secrets.auth.pipedrive" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Reddit */}}
          {{- if .Values.linkwarden.auth.sso.reddit.enabled }}
          - name: REDDIT_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.reddit.existingSecret | default (include "linkwarden.secrets.auth.reddit" .) }}
                key: "clientId"
          - name: REDDIT_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.reddit.existingSecret | default (include "linkwarden.secrets.auth.reddit" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Salesforce */}}
          {{- if .Values.linkwarden.auth.sso.salesforce.enabled }}
          - name: SALESFORCE_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.salesforce.existingSecret | default (include "linkwarden.secrets.auth.salesforce" .) }}
                key: "clientId"
          - name: SALESFORCE_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.salesforce.existingSecret | default (include "linkwarden.secrets.auth.salesforce" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Slack */}}
          {{- if .Values.linkwarden.auth.sso.slack.enabled }}
          - name: SLACK_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.slack.existingSecret | default (include "linkwarden.secrets.auth.slack" .) }}
                key: "clientId"
          - name: SLACK_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.slack.existingSecret | default (include "linkwarden.secrets.auth.slack" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Spotify */}}
          {{- if .Values.linkwarden.auth.sso.spotify.enabled }}
          - name: SPOTIFY_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.spotify.existingSecret | default (include "linkwarden.secrets.auth.spotify" .) }}
                key: "clientId"
          - name: SPOTIFY_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.spotify.existingSecret | default (include "linkwarden.secrets.auth.spotify" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Strava */}}
          {{- if .Values.linkwarden.auth.sso.strava.enabled }}
          - name: STRAVA_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.strava.existingSecret | default (include "linkwarden.secrets.auth.strava" .) }}
                key: "clientId"
          - name: STRAVA_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.strava.existingSecret | default (include "linkwarden.secrets.auth.strava" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Todoist */}}
          {{- if .Values.linkwarden.auth.sso.todoist.enabled }}
          - name: TODOIST_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.todoist.existingSecret | default (include "linkwarden.secrets.auth.todoist" .) }}
                key: "clientId"
          - name: TODOIST_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.todoist.existingSecret | default (include "linkwarden.secrets.auth.todoist" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Twitch */}}
          {{- if .Values.linkwarden.auth.sso.twitch.enabled }}
          - name: TWITCH_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.twitch.existingSecret | default (include "linkwarden.secrets.auth.twitch" .) }}
                key: "clientId"
          - name: TWITCH_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.twitch.existingSecret | default (include "linkwarden.secrets.auth.twitch" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* United Effects */}}
          {{- if .Values.linkwarden.auth.sso.unitedEffects.enabled }}
          - name: UNITED_EFFECTS_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.unitedEffects.existingSecret | default (include "linkwarden.secrets.auth.unitedEffects" .) }}
                key: "clientId"
          - name: UNITED_EFFECTS_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.unitedEffects.existingSecret | default (include "linkwarden.secrets.auth.unitedEffects" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* VK */}}
          {{- if .Values.linkwarden.auth.sso.vk.enabled }}
          - name: VK_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.vk.existingSecret | default (include "linkwarden.secrets.auth.vk" .) }}
                key: "clientId"
          - name: VK_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.vk.existingSecret | default (include "linkwarden.secrets.auth.vk" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Wikimedia */}}
          {{- if .Values.linkwarden.auth.sso.wikimedia.enabled }}
          - name: WIKIMEDIA_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.wikimedia.existingSecret | default (include "linkwarden.secrets.auth.wikimedia" .) }}
                key: "clientId"
          - name: WIKIMEDIA_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.wikimedia.existingSecret | default (include "linkwarden.secrets.auth.wikimedia" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Wordpress */}}
          {{- if .Values.linkwarden.auth.sso.wordpress.enabled }}
          - name: WORDPRESS_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.wordpress.existingSecret | default (include "linkwarden.secrets.auth.wordpress" .) }}
                key: "clientId"
          - name: WORDPRESS_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.wordpress.existingSecret | default (include "linkwarden.secrets.auth.wordpress" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Yandex */}}
          {{- if .Values.linkwarden.auth.sso.yandex.enabled }}
          - name: YANDEX_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.yandex.existingSecret | default (include "linkwarden.secrets.auth.yandex" .) }}
                key: "clientId"
          - name: YANDEX_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.yandex.existingSecret | default (include "linkwarden.secrets.auth.yandex" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Zitadel */}}
          {{- if .Values.linkwarden.auth.sso.zitadel.enabled }}
          - name: ZITADEL_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.zitadel.existingSecret | default (include "linkwarden.secrets.auth.zitadel" .) }}
                key: "clientId"
          - name: ZITADEL_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.zitadel.existingSecret | default (include "linkwarden.secrets.auth.zitadel" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Zoho */}}
          {{- if .Values.linkwarden.auth.sso.zoho.enabled }}
          - name: ZOHO_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.zoho.existingSecret | default (include "linkwarden.secrets.auth.zoho" .) }}
                key: "clientId"
          - name: ZOHO_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.zoho.existingSecret | default (include "linkwarden.secrets.auth.zoho" .) }}
                key: "clientSecret"                        
          {{- end }}
          {{-/* Zoom */}}
          {{- if .Values.linkwarden.auth.sso.zoom.enabled }}
          - name: ZOOM_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.zoom.existingSecret | default (include "linkwarden.secrets.auth.zoom" .) }}
                key: "clientId"
          - name: ZOOM_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: {{ .Values.linkwarden.auth.sso.zoom.existingSecret | default (include "linkwarden.secrets.auth.zoom" .) }}
                key: "clientSecret"                        
          {{- end }}
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        volumeMounts:
          - name: {{ include "linkwarden.pv.name" . }}
            mountPath: {{ .Values.linkwarden.data.rootPath | default "/data" }}
        {{- if .Values.resources }}
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
        {{- end }}
        {{- if .Values.securityContext }}
        securityContext:
          {{- toYaml .Values.securityContext | nindent 12 }}
        {{- end }}
        {{- if .Values.livenessProbe.enabled }}
        livenessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.livenessProbe.periodSeconds }}
          timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds }}
          successThreshold: {{ .Values.livenessProbe.successThreshold }}
          failureThreshold: {{ .Values.livenessProbe.failureThreshold }}
        {{- end }}
        {{- if .Values.readinessProbe.enabled }}
        livenessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
          timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
          successThreshold: {{ .Values.readinessProbe.successThreshold }}
          failureThreshold: {{ .Values.readinessProbe.failureThreshold }}
        {{- end }}
        {{- if .Values.startupProbe.enabled }}
        livenessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: {{ .Values.startupProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.startupProbe.periodSeconds }}
          timeoutSeconds: {{ .Values.startupProbe.timeoutSeconds }}
          successThreshold: {{ .Values.startupProbe.successThreshold }}
          failureThreshold: {{ .Values.startupProbe.failureThreshold }}
        {{- end }}
    {{- if eq .Values.linkwarden.data.storageType "filesystem" }}
    volumes:
      - name: {{ include "linkwarden.pv.name" . }}
        persistentVolumeClaim:
          claimName: {{ include "linkwarden.pvc.name" . }}
    {{- end }}
    {{- if .Values.nodeSelector }}
    nodeSelector:
      {{- toYaml .Values.nodeSelector | nindent 8 }}
    {{- end }}
    {{- if .Values.affinity }}
    affinity:
      {{- toYaml .Values.affinity | nindent 8 }}
    {{- end }}
    {{- if .Values.tolerations }}
    tolerations:
      {{- toYaml .Values.tolerations | nindent 8 }}
    {{- end }}
    {{- if .Values.podSecurityContext }}
    securityContext:
      {{- toYaml .Values.podSecurityContext | nindent 8 }}
    {{- end }}
    {{- if .Values.initContainers }}
    initContainers:
      {{- toYaml .Values.initContainers | nindent 8 }}
    {{- end }}
{{- end }}