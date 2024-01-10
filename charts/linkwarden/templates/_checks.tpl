{{/* 
  SSO Authentication providers 
*/}}
{{- define "linkwarden.auth.providers" -}}
  {{- $list := list "fortytwo" "apple" "atlassian" "auth0" "authentik" "battleNet" "box" "bungie" "cognito" "coinbase" "discord" "dropbox" "duende_ids6" "eveOnline" "facebook" "faceit" "foursquare" "freshbooks" "fusionauth" "freshbooks" "github" "gitlab" "google" "hubspot" "ids4" "kakao" "keycloak" "line" "linkedin" "mailchimp" "mailru" "naver" "netlify" "okta" "onelogin" "osso" "osu!" "patreon" "pinterest" "pipedrive" "reddit" "salesforce" "slack" "spotify" "strava" "todoist" "twitch" "unitedEffects" "vk" "wikimedia" "wordpress" "yandex" "zitadel" "zoho" "zoom" }}
  {{- $list | toJson }}
{{- end }}

{{- define "linkwarden.auth.providers.withIssuers" }}
  {{- $list := list "auth0" "authentik" "battleNet" "box" "cognito" "ids6" "fusionauth" "ids4" "keycloak" "okta" "onelogin" "osso" "unitedEffects" "zitadel" }}
  {{- $list | toJson }}
{{- end }}

{{/* 
  Check whether a domain is given if the Ingress is enabled
*/}}
{{- define "linkwarden.checks.domain" -}}
  {{- if .Values.ingress.enabled }}
  {{- if not .Values.linkwarden.domain }}
  {{- fail "You did not provide domain name for the installation but enabled the Ingress. Please set '.Values.linkwarden.domain' also." }}
  {{- end }}
  {{- end }}
{{- end -}}

{{/* 
  Check whether the given SSO providers are allowed - if any are actually provided
*/}}
{{- define "linkwarden.checks.providers" -}}
{{- $allowedList := include "linkwarden.auth.providers.withIssuers" . | fromJsonArray }}
{{- $authSSOLength := len .Values.linkwarden.auth.sso }}
  {{- if (gt $authSSOLength 0) }}
  {{- range $_, $v := .Values.linkwarden.auth.sso }}
  {{- if not (has $v.provider $allowedList) }}
  {{ fail "Your given SSO provider is not allowed. Please see 'values.yaml' comments for a list of allowed providers." }}
  {{- end }}
  {{- end }}
  {{- end }}
{{- end -}}