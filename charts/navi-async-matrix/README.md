# DM Async

This repository contains a [Helm chart](https://helm.sh/docs/topics/charts/)
for deploying [DM Async](https://gitlab.2gis.ru/traffic/dm_async_service/)

## Installing

Before installation, make sure that you have:

* Kafka cluster with:
  * required topics
  * user with read/write/describe access to the topics
* S3 bucket

To install, create `values.yaml` file with the following content:
* docker registry
* castle URL
* existing s3 bucket connection parameters
* existing PostgreSQL DB details
* Kafka details and names of existing topics:
  * cancel topic
  * task topic
  * request topics for projects

```yaml
dgctlDockerRegistry: docker-hub.2gis.ru

dm:
  citiesUrl: 'http://castle1.example.com/cities.conf'

s3:
  url: "http://s3.example.com:80"
  bucket: "test-bucket"
  keyId: somekey
  key: somes3secret

db:
  host: example.com
  port: 5432
  name: dmasync
  user: dbuser
  password: dbpassword

kafka:
  bootstrap: "kafka.example.com:31000"
  groupId: sample_kafka_group_id
  user: kafkauser
  password: kafkasecretpassword
  consumerTaskTopic: task_topic_name
  consumerCancelTopic: cancel_topic_name
  topicRules:
  - topic: request_topic_name
    default: true
  - topic: dammam_request_topic
    projects:
    - dammam
```

Then, call the `helm install` command and specify the name of the created file:

```shell
helm install navi-async-matrix . -f values.yaml
```

## Updating

To update the service after changing the settings or after updating
the Docker image, call `helm upgrade` command:

```bash
helm upgrade navi-async-matrix . -f values.yaml
```
