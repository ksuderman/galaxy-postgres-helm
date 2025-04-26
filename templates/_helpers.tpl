{{/*
Expand the name of the chart.
*/}}
{{- define "galaxy-postgres-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "galaxy-postgres-helm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "galaxy-postgres-helm.pv" -}}
{{- printf "%s-%s-pv" .Release.Namespace .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "galaxy-postgres-helm.postgres-credentials" -}}
{{- printf "%s-postgres-secret" .Release.Name }}
{{- end }}

{{- define "galaxy-postgres-helm.galaxy-credentials" -}}
{{- printf "%s-galaxy-secret" .Release.Name }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "galaxy-postgres-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "galaxy-postgres-helm.labels" -}}
helm.sh/chart: {{ include "galaxy-postgres-helm.chart" . }}
{{ include "galaxy-postgres-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "galaxy-postgres-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "galaxy-postgres-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "galaxy-postgres-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "galaxy-postgres-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
