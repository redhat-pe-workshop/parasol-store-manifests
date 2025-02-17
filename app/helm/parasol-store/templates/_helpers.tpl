{{/*
Expand the name of the chart.
*/}}
{{- define "parasol-store.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "parasol-store.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "parasol-store.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "parasol-store.labels" -}}
helm.sh/chart: {{ include "parasol-store.chart" . }}
{{ include "parasol-store.selectorLabels" . }}
{{ include "backstage.labels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "parasol-store.selectorLabels" -}}
app.kubernetes.io/name: {{ include "parasol-store.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Backstage labels
*/}}
{{- define "backstage.labels" -}}
{{- if .Values.backstage.id }}
backstage.io/kubernetes-id: {{ .Values.backstage.id }}
{{- else }}
backstage.io/kubernetes-id: {{ include "parasol-store.name" . }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "parasol-store.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "parasol-store.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "parasol-store.image" -}}
{{- printf "%s/%s/%s" .Values.image.host .Values.image.organization .Values.image.name -}}
{{- end }}

{{- define "quay.auth" -}}
{{- $auth:= printf "%s:%s" .Values.registry.username .Values.registry.password -}}
{{- $auth | b64enc -}}
{{- end }}

{{- define "database.namespace" -}}
{{- if .Values.database.namespace }}
{{- .Values.database.namespace }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}
