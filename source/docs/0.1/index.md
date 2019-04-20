## What is Moleculer?

Moleculer is a simple, fast, modern and powerful microservices framework written in Go (https://golang.org/).

It helps you to build simple, efficient, reliable & scalable services.

Easy to go from 1 machine to many machines. Easy to focus on your problem.

## Features

-   request-reply concept
-   support streams
-   support event driven architecture with balancing
-   built-in service registry & dynamic service discovery
-   load balanced requests & events (round-robin, random, cpu-usage, latency)
-   many fault tolerance features (Circuit Breaker, Bulkhead, Retry, Timeout, Fallback)
-   supports middlewares
-   supports versioned services
-   service mixins
-   built-in caching solution (memory, Redis)
-   pluggable transporters (TCP, NATS, MQTT, Redis, NATS Streaming, Kafka)
-   pluggable serializers (JSON, Avro, MsgPack, Protocol Buffer, Thrift)
-   pluggable validator
-   multiple services on a node/server
-   all nodes are equal, no master/leader node

## How fast?

![Under Construction](https://img.shields.io/badge/under-construction-red.svg)

{% note info Versioning %}
Until Moleculer reaches a `1.0` release, breaking changes will be released with a new minor version. For example `0.1.1`, and `0.1.4` will be backward compatible, but `0.2.0` will have breaking changes.
{% endnote %}
