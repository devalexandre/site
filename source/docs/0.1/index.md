# What is Moleculer?

---

Moleculer is a simple, fast, modern and powerful microservices framework written in Go (https://golang.org/).

It helps you to build simple, efficient, reliable & scalable services.

Easy to go from 1 machine to many machines. Easy to focus on your problem.

## Example

![Example](/images/main-example.png)

# Roadmap

![Timeline](/images/timeline.png)

## v0.1.0 (MVP)

Development is `complete` - Documentation is `in-progress` and benchmark is also `in-progress`.

**Contents:**

-   Service Broker
-   Transit and Transport
-   Actions (request-reply)
-   Events
-   Mixins
-   Load balancing for actions and events (random round-robin)
-   Service registry & dynamic service discovery
-   Versioned services
-   Middlewares
-   NATS Streaming Transporter
-   JSON Serializer
-   Examples :)

## v0.2.0 (Beta RC1)

-   Action validators
-   Support for streams
-   More Load balancing implementations (cpu-usage, latency)
-   Fault tolerance features (Circuit Breaker, Bulkhead, Retry, Timeout, Fallback)
-   Built-in caching solution (memory, Redis)
-   More transporters (gRPC, TCP, Redis, Kafka)
-   More serializers (Avro, MsgPack, Protocol Buffer, Thrift)

## v0.3.0 (Beta)

-   Performance and Optimization
-   More DB Adaptors (SQLLite, Firebase, MySQL)
-   CLI for Project Seed Generation

## v0.4.0 (Alpha)

-   Event Sourcing Mixins

## v0.5.0 (Release)

# Installation

```bash
$ go get github.com/moleculer-go/moleculer
```

# Running examples

```bash

# simple moleculer db example with memory adaptor
$ go run github.com/moleculer-go/moleculer-db/examples/users

# simple moleculer db example with Mongo adaptor
$ go run github.com/moleculer-go/moleculer-db/examples/usersMongo

# complex moleculer db example with population of fields by other services
$ go run github.com/moleculer-go/moleculer-db/examples/populates


```

{% note info Versioning %}
Until Moleculer reaches a `1.0` release, breaking changes will be released with a new minor version. For example `0.1.1`, and `0.1.4` will be backward compatible, but `0.2.0` will have breaking changes.
{% endnote %}
