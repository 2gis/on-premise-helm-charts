# 2GIS Tiles API service

Use this Helm chart to deploy Tiles API service, which is a part of 2GIS's [On-Premise Maps services](https://docs.2gis.com/en/on-premise/map).

Read more about the On-Premise solution [here](https://docs.2gis.com/en/on-premise/overview).

> **Note:**
>
> All On-Premise services are beta, and under development.

See the [documentation](https://docs.2gis.com/en/on-premise/map) to learn how to:

- Install the service.

    When filling in the keys for `values-tiles.yaml` configuration file, refer to the documentation and the list of keys below.

- Update the service.

## Values

### "Docker Registry."

| Name                  | Description                                                                               | Value |
| --------------------- | ----------------------------------------------------------------------------------------- | ----- |
| `dgctlDockerRegistry` | "Docker Registry endpoint where On-Premise services' images reside. Format: `host:port`." | `""`  |


### "Deployment Artifacts Storage"

| Name                     | Description                                                                                                                                                                                                                                           | Value |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `dgctlStorage`           |                                                                                                                                                                                                                                                       |       |
| `dgctlStorage.host`      | "S3 endpoint. Format: `host:port`."                                                                                                                                                                                                                   | `""`  |
| `dgctlStorage.bucket`    | "S3 bucket name."                                                                                                                                                                                                                                     | `""`  |
| `dgctlStorage.accessKey` | "S3 access key for accessing the bucket."                                                                                                                                                                                                             | `""`  |
| `dgctlStorage.secretKey` | "S3 secret key for accessing the bucket."                                                                                                                                                                                                             | `""`  |
| `dgctlStorage.manifest`  | The path to the [manifest file](https://docs.2gis.com/en/on-premise/overview#nav-lvl2--Common_deployment_steps). Format: `manifests/0000000000.json`. <br> This file contains the description of pieces of data that the service requires to operate. | `""`  |


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| 2gis | on-premise@2gis.com | https://github.com/2gis |
