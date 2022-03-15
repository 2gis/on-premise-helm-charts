# 2GIS API Keys service (Helm chart)

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/) for deploying the API Keys service. This
service is part of 2GIS On-Premise services, which allow you to deploy [2GIS products](https://dev.2gis.com/) on your
own sites.

To learn more about 2GIS On-Premise services, visit [docs.2gis.com](https://docs.2gis.com/en/on-premise/overview).

## Installing

Before installing API Keys service, make sure that you have a running PostgreSQL instance with installed `pg_trgm` extension.

To install the service create a YAML file that will contain:

- Registry URL of the service's Docker image
- PostgreSQL access parameters
- Keys API URL for Admin panel

```yaml
# Docker image
backend:
  image:
    repository: your-docker-hub/2gis/keys-backend

# PostgreSQL access
db:
  ro:
    host: localhost
    port: 5432
    name: keys
    username: keys
    password: secret
  rw:
    host: localhost
    port: 5432
    name: keys
    username: keys
    password: secret

# LDAP
ldap:
  host: 2gis.local
  port: 3268

  useStartTLS: false
  useLDAPS: false
  skipServerCertificateVerify: false
  serverName: ""
  clientCertificatePath: ""
  clientKeyPath: ""
  rootCertificateAuthoritiesPath: ""

  bind:
    dn: user
    password: secret
  search:
    baseDN: "dc=2gis"
    filter: "(&(objectClass=user)(sAMAccountName=%s))"

# Admin
admin:
  image:
    repository: your-docker-hub/2gis/keys-admin

  apiUrl: "https://api.url/admin/v1"
  appHost: "https://app.host"
```

To install/upgrade use `helm upgrade` command and specify path to the created file with values. If you are doing a fresh
install or data migrate/upgrade, you need to set value of `install.apps` to `false`. Example command for fresh
installation:

```shell
helm repo add 2gis-on-premise https://2gis.github.io/on-premise-helm-charts
helm upgrade keys 2gis-on-premise/keys \
  --install --atomic --wait-for-jobs \
  --values values.yaml \
  --set install.apps=false
```

Add users that can authorize in AD/LDAP (users don't sync between systems) using `keysctl` inside any `keys-api` pod:

```shell
keysctl users add "username" "Display Name"
```

If you haven't LDAP or LDAP don't work, you may to set value of `api.adminUsers`
with list of usernames and passwords (will be store in secret). For example, `admin:$uperPassw0rd`.

Get list of services with their API keys:

```shell
keysctl services
```

## Updating

To update the service data or apps after changing the settings or after updating the Docker image, use
the `helm upgrade` command:

```bash
helm upgrade keys 2gis-on-premise/keys \
  --atomic --wait-for-jobs \
  --values keys-values.yaml
```
