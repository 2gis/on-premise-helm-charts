В директории `services/` можно описывать собственные релизы, отсутствующие в инсталляторе
(кластерные утилиты, внутренние приложения) — шаблоны релизов в вашем values-каталоге.

Каждый сервис - отдельный файл `services/<name>.yaml.gotmpl`; подключается строкой в списке
`helmfiles:` файла `deploy/<env>.yaml.gotmpl`:

```
helmfiles:
- path: {{ .Values.valuesPath }}/services/<name>.yaml.gotmpl
```

Содержимое `services/<name>.yaml.gotmpl`:

```gotmpl
---
bases:
- {{ env "HELMFILE_BASE" | default (printf "%s/installer/helmfile" (env "PWD")) }}/common.yaml.gotmpl

---
releases:
- name: <name>
  namespace: {{ .Values.namespace }}
  chart: <chart>                  # OCI инсталлятора ({{ .Values.chartLocation }}/<chart>) или свой repository
  version: {{ .Values.versionPlatform }}
  kubeContext: {{ .Values.kubeContext }}
  labels:                          # селекторы group/service работают как у штатных сервисов
    group: <group>
    service: <name>
  values:
  - {{ .Values.valuesPath }}/values/<group>/<name>/{{ .Environment.Name }}.yaml.gotmpl
  {{- $dep := printf "%s/values/<group>/<name>/_common.yaml.gotmpl" .Values.valuesPath }}
  {{- if isFile $dep }}
  - {{ $dep }}
  {{- end }}
```

Дополнительно:
- `.Values` шаблона содержит env-карту (имена релизов, kubeContext, dgctlStorage и т.д.);
- секреты сервиса - `values/<group>/<name>/<env>.secrets.yaml` через поле `secrets:`
  (sops/helm-secrets, см. "Секреты");
- деплой и селекция - те же команды: `helmfile -e <env> -f $HELMFILE_VALUES/deploy/<env>.yaml.gotmpl \
  apply --selector service=<name>`.
