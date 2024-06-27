{{/*
  Supported databases
*/}}
{{- define "gobackup.conf.databases" -}}
  {{- $list := list "mysql" "postgresql" "mongodb" "mssql" "redis" "sqlite" "influxdb2" "mariadb" "etcd" }}
  {{- $list | toJson }}
{{- end }}

{{- define "gobackup.conf.storages" -}}
  {{- $list := list "local" "ftp" "sftp" "scp" "webdav" "s3" "oss" "gcs" "azure" "r2" "spaces" "b2" "cos" "us3" "kodo" "bos" "minio" "obs" "tos" "upyun" }}
  {{- $list | toJson }}
{{- end }}

{{- define "gobackup.conf.notifiers" -}}
  {{- $list := list "mail" "webhook" "discord" "slack" "telegram" "dingtalk" "feishu" "ses" "postmark" "sendgrid" }}
  {{- $list | toJson }}
{{- end }}


