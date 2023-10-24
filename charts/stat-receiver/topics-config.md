```yaml
- topic: "{{ topic-name-prefix }}input"
  partitions: {{ partitions }}
  replica-factor: {{ replica-factor }}
  options:
    retention.ms: {{ retention }}
    cleanup.policy: delete

- topic: "{{ topic-name-prefix }}invalid-messages"
  partitions: {{ partitions }}
  replica-factor: {{ replica-factor }}
  options:
    retention.ms: {{ retention }}
    cleanup.policy: delete

- topic: "{{ topic-name-prefix }}unknown-type"
  partitions: {{ partitions }}
  replica-factor: {{ replica-factor }}
  options:
    retention.ms: {{ retention }}
    cleanup.policy: delete

- topic: "{{ topic-name-prefix }}type.401"
  partitions: {{ partitions }}
  replica-factor: {{ replica-factor }}
  options:
    retention.ms: {{ retention }}
    cleanup.policy: delete

- topic: "{{ topic-name-prefix }}streams-unique-message-batches-changelog"
  partitions: {{ partitions }}
  replica-factor: {{ replica-factor }}
  options:
    retention.ms: {{ retention }}
    cleanup.policy: compact,delete
    message.timestamp.type: CreateTime
```
