# Modules

---

{% note info WIP Documentation %}

<img src="assets/under_construction.png" width=150/>

This documentation is still a working in progress and this page has not been fully converted yet :(

We are working on top of the existing Moleculer JS documentation, and that is why you might see pages with some JavaScript :)
{% endnote %}

## Official modules

### General

| Module name                                                                                                      | Description                                          | Version                                                                                                             |
| ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| [gateway](gateway.html)                                                                                          | Official API Gateway service for Moleculer framework |                                                                                                                     |
| [moleculer-fake](https://github.com/moleculerjs/moleculer-addons/tree/master/packages/moleculer-fake#readme)     | Fake data generator by Fakerator.                    | [![NPM version](https://img.shields.io/npm/v/moleculer-fake.svg)](https://www.npmjs.com/package/moleculer-fake)     |
| [moleculer-mail](https://github.com/moleculerjs/moleculer-addons/tree/master/packages/moleculer-mail#readme)     | Send emails from any services.                       | [![NPM version](https://img.shields.io/npm/v/moleculer-mail.svg)](https://www.npmjs.com/package/moleculer-mail)     |
| [moleculer-twilio](https://github.com/moleculerjs/moleculer-addons/tree/master/packages/moleculer-twilio#readme) | Send SMS Message with Twilio.                        | [![NPM version](https://img.shields.io/npm/v/moleculer-twilio.svg)](https://www.npmjs.com/package/moleculer-twilio) |
| [moleculer-slack](https://github.com/moleculerjs/moleculer-addons/tree/master/packages/moleculer-slack#readme)   | Send Messages to Slack.                              | [![NPM version](https://img.shields.io/npm/v/moleculer-slack.svg)](https://www.npmjs.com/package/moleculer-slack)   |

### Databases & stores

| Module name                                                                                                         | Description                                                             | Version                                                                                                                           |
| ------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [store](https://github.com/moleculerjs/store/tree/master/packages/store#readme)                                     | Moleculer service to store entities in database.                        | [![NPM version](https://img.shields.io/npm/v/store.svg)](https://www.npmjs.com/package/store)                                     |
| [store-adapter-mongo](https://github.com/moleculerjs/store/tree/master/packages/store-adapter-mongo#readme)         | MongoDB native adapter for Moleculer DB service.                        | [![NPM version](https://img.shields.io/npm/v/store-adapter-mongo.svg)](https://www.npmjs.com/package/store-adapter-mongo)         |
| [store-adapter-mongoose](https://github.com/moleculerjs/store/tree/master/packages/store-adapter-mongoose#readme)   | Mongoose adapter for Moleculer DB service.                              | [![NPM version](https://img.shields.io/npm/v/store-adapter-mongoose.svg)](https://www.npmjs.com/package/store-adapter-mongoose)   |
| [store-adapter-sequelize](https://github.com/moleculerjs/store/tree/master/packages/store-adapter-sequelize#readme) | SQL adapter (Postgres, MySQL, SQLite & MSSQL) for Moleculer DB service. | [![NPM version](https://img.shields.io/npm/v/store-adapter-sequelize.svg)](https://www.npmjs.com/package/store-adapter-sequelize) |

### Tasks, queues & jobs

| Module name                                                                                                            | Description                     | Version                                                                                                                   |
| ---------------------------------------------------------------------------------------------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| [moleculer-bee-queue](https://github.com/moleculerjs/moleculer-addons/tree/master/packages/moleculer-bee-queue#readme) | Task queue mixin for Bee-Queue. | [![NPM version](https://img.shields.io/npm/v/moleculer-bee-queue.svg)](https://www.npmjs.com/package/moleculer-bee-queue) |
| [moleculer-bull](https://github.com/moleculerjs/moleculer-addons/tree/master/packages/moleculer-bull#readme)           | Task queue service with Bull.   | [![NPM version](https://img.shields.io/npm/v/moleculer-bull.svg)](https://www.npmjs.com/package/moleculer-bull)           |
| [moleculer-cron](https://github.com/davidroman0O/moleculer-cron#readme)                                                | Cron tasks.                     | [![NPM version](https://img.shields.io/npm/v/moleculer-cron.svg)](https://www.npmjs.com/package/moleculer-cron)           |

### Metrics & Tracing

| Module name                                                                                                                       | Description                                                  | Version                                                                                                                                 |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| [moleculer-console-tracer](https://github.com/moleculerjs/moleculer-metrics/blob/master/packages/moleculer-console-tracer#readme) | Simple tracer service to print metric traces to the console. | [![npm](https://img.shields.io/npm/v/moleculer-console-tracer.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-console-tracer) |
| [moleculer-jaeger](https://github.com/moleculerjs/moleculer-metrics/blob/master/packages/moleculer-jaeger#readme)                 | Moleculer metrics module for Jaeger.                         | [![npm](https://img.shields.io/npm/v/moleculer-jaeger.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-jaeger)                 |
| [moleculer-prometheus](https://github.com/moleculerjs/moleculer-metrics/blob/master/packages/moleculer-prometheus#readme)         | Moleculer metrics module for Prometheus.                     | [![npm](https://img.shields.io/npm/v/moleculer-prometheus.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-prometheus)         |
| [moleculer-zipkin](https://github.com/moleculerjs/moleculer-metrics/blob/master/packages/moleculer-zipkin#readme)                 | Moleculer metrics module for Zipkin.                         | [![npm](https://img.shields.io/npm/v/moleculer-zipkin.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-zipkin)                 |

### Tools

| Module name                           | Description                                | Version                                                                                                             |
| ------------------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| [moleculer-repl](moleculer-repl.html) | REPL module for Moleculer framework.       | [![npm](https://img.shields.io/npm/v/moleculer-repl.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-repl) |
| [moleculer-cli](moleculer-cli.html)   | Command line tool for Moleculer framework. | [![npm](https://img.shields.io/npm/v/moleculer-cli.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-cli)   |

## Third-party modules

### General

| Module name                                                                                            | Author                                            | Description                                                                           | Version                                                                                                                                               |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------- | ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [moleculer-adapter-feathers](https://github.com/zygos/moleculer-adapter-feathers#readme)               | [zygos](zygos)                                    | Moleculer service mixin wrapping Feathers.js services.                                | [![NPM version](https://img.shields.io/npm/v/moleculer-adapter-feathers.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-adapter-feathers)   |
| [moleculer-decorators](https://github.com/ColonelBundy/moleculer-decorators#readme)                    | [ColonelBundy](https://github.com/ColonelBundy)   | Decorators for Moleculer framework.                                                   | [![npm](https://img.shields.io/npm/v/moleculer-decorators.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-decorators)                       |
| [moleculer-graphql](https://github.com/ConciergeAuctions/moleculer-graphql#readme)                     | [brad-decker](https://github.com/brad-decker)     | GraphQL Schema stitching over a microservice network for co-located type definitions. | [![npm](https://img.shields.io/npm/v/moleculer-graphql.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-graphql)                             |
| [moleculer-sc](https://github.com/tiaod/moleculer-sc#readme)                                           | [tiaod](https://github.com/tiaod)                 | API Gateway service for Moleculer framework using SocketCluster.                      | [![npm](https://img.shields.io/npm/v/moleculer-sc.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-sc)                                       |
| [moleculer-json-schema-validator](https://github.com/zhaoyao91/moleculer-json-schema-validator#readme) | [zhaoyao91](https://github.com/zhaoyao91)         | JSON Schema Validator with ajv.                                                       | [![npm](https://img.shields.io/npm/v/moleculer-json-schema-validator.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-json-schema-validator) |
| [moleculer-flydrive](https://github.com/molobala/moleculer-flydrive#readme)                            | [molobala](https://github.com/molobala)           | Fluent storage manager service with Node Flydrive.                                    | [![npm](https://img.shields.io/npm/v/moleculer-flydrive.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-flydrive)                           |
| [moleculer-elastic-apm](https://github.com/intech/moleculer-elastic-apm)                               | [Ivan Zhuravlev](https://github.com/intech)       | Metrics to Elastic APM Agent.                                                         | [![npm](https://img.shields.io/npm/v/moleculer-elastic-apm.svg?maxAge=3600)](https://www.npmjs.com/package/moleculer-elastic-apm)                     |
| [hapi-moleculer](https://github.com/felipegcampos/hapi-moleculer)                                      | [felipegcampos](https://github.com/felipegcampos) | Hapi plugin for the Moleculer Microservices Framework.                                | [![npm](https://img.shields.io/npm/v/hapi-moleculer.svg?maxAge=3600)](https://www.npmjs.com/package/hapi-moleculer)                                   |
| [imicros-flow](https://github.com/al66/imicros-flow)                                                   | [al66](https://github.com/al66)                   | Moleculer service for loose coupled event handling.                                   | [![npm](https://img.shields.io/npm/v/imicros-flow.svg?maxAge=3600)](https://www.npmjs.com/package/imicros-flow)                                       |

> Do you have a custom module for Moleculer? [Tell us!](https://github.com/moleculerjs/moleculer/issues)
