# Services

---

The `Service` represents a microservice in the Moleculer framework. You can define actions and subscribe to events. To create a service can use a schema directly, or use a simple struct.

![Gopher Services](assets/gopher-services.jpg)

## Schema

The schema has some main parts: `name`, `version`, `settings`, `actions`, and `events`.

### Simple service schema to define two actions

```go
var mathService = moleculer.ServiceSchema{
  Name: "math",
  Actions: []moleculer.Action{
    {
      Name:  "add",
      Handler: func addAction(ctx moleculer.Context, params moleculer.Payload) interface{} {
        return params.Get("a").Int() + params.Get("b").Int()
      },
    },
    {
      Name:  "sub",
      Handler: func(ctx moleculer.Context, params moleculer.Payload) interface{} {
        return params.Get("a").Int() - params.Get("b").Int()
      },
    },
  },
}
```

## Base properties

The Service has some base properties in the schema.

```go
moleculer.ServiceSchema{
  Name: "posts",
}
```

The `Name` is a mandatory property so it must be defined. It's the first part of action name when you call it.

The `Version` is an optional property. Use it to run multiple version from the same service. It is a prefix in the action name.

```go
moleculer.ServiceSchema{
  Name: "posts",
  Version: "2",
  Actions: []moleculer.Action{
    {
      Name:  "find",
      Handler: ...,
    },
  },
}
```

<img src="assets/under_construction.png" width=150/> `version as prefix on action names is not implemented yet.`

To call this `find` action on version `2` service:

```go
broker.Call("v2.posts.find", nil);
```

{% note info REST call %}
Via [API Gateway](moleculer-web.html), make a request to `GET /v2/posts/find`.
{% endnote %}

## Settings

The `settings` property is a key-value store, where you can store every settings/options to your service.

```go
var instanceSettings map[string]interface{}
moleculer.ServiceSchema{
 Name: "mailer",
 Settings: map[string]interface{}{
  "transport": "mailgun",
 },
 Created: func(s moleculer.ServiceSchema, l *log.Entry) {
  instanceSettings = svc.Settings
 },
 Actions: []moleculer.Action{
  {
   Name:  "send",
   Handler: func(ctx moleculer.Context, p moleculer.Payload) interface{} {
    if instanceSettings["transport"] == "mailgun" {
     //.. do something
    }
   },
  },
 }
}
```

> The `settings` is also obtainable on remote nodes. It is transferred during service discovering.

## Mixins

Mixins are a flexible way to distribute reusable functionalities for Moleculer services. Moleculer will merges the mixins actions, lifecycle methods with the service schema.
In this way you can extend services and resuse functionality. When a service uses mixins, all actions, settings, and lifecycle methods are "mixed" into the service.

**Example using `moleculer-db`**

```go
moleculer.ServiceSchema{
  Name: "users",
  Settings: map[string]interface{}{
  	"fields":    []string{"_id", "username", "name"},
  	"populates": map[string]interface{}{"friends": "users.get"},
  },
  Mixins: []moleculer.Mixin{
    db.Mixin(&db.MongoAdapter{
  	  MongoURL:   "mongodb://localhost:27017",
  	  Collection: "users",
  	  Database:   "test",
  	  Timeout:    time.Second * 5,
   })},
  Actions: []moleculer.Action{
  {
   Name:  "notify",
   Handler:...,
  },
 }
}
```

The above example creates an `users` service which inherits all from `db.Mixin`, overwrite the fields and populates setting and expose a new action called `notify`.

### Merge algorithm

The merge algorithm depends on the property type.

| Property                        | Algorithm              |
| ------------------------------- | ---------------------- |
| `Name`, `Version`               | Merge & overwrite.     |
| `Settings`                      | Merge & overwrite.     |
| `Metadata`                      | Merge & overwrite.     |
| `Actions`                       | Merge & overwrite.     |
| `Hooks`                         | Merge & overwrite.     |
| `Events`                        | Concatenate listeners. |
| `Created`, `Started`, `Stopped` | Concatenate listeners. |
| `Mixins`                        | Merge & overwrite.     |
| `Dependencies`                  | Merge & overwrite.     |
| any other                       | Merge & overwrite.     |

{% note info Merge algorithm examples %}
**Merge & overwrite**: if serviceA has `a: 5`, `b: 8` and serviceB has `c: 10`, `b: 15`, the mixed service will have `a: 5`, `b: 15` and `c: 10`.
**Concatenate**: if serviceA & serviceB subscribe to `users.created` event, both event handler will be called when the `users.created` event emitted.
{% endnote %}

## Actions

The actions are the callable/public methods of the service. They are callable with `broker.call` or `ctx.call`.

```go
moleculer.ServiceSchema{
  Name: "math",
  Actions: []moleculer.Action{
    {
      Name:  "add",
      Handler: func addAction(ctx moleculer.Context, params moleculer.Payload) interface{} {
        return params.Get("a").Int() + params.Get("b").Int()
      },
    },
    {
      Name:  "sub",
      Handler: func(ctx moleculer.Context, params moleculer.Payload) interface{} {
        return params.Get("a").Int() - params.Get("b").Int()
      },
    },
  },
}
```

You can call the above actions as

```go
res := <-bkr.Call("math.add", map[string]int{ "a": 5, "b": 7 });
res := <-bkr.Call("math.mult", map[string]int{ "a": 10, "b": 31 });
```

Inside actions, you can call other nested actions in other services with `ctx.call` method. It is an alias to `broker.call`, but it sets itself as parent context for tracing purposes.

```go
moleculer.ServiceSchema{
  Name: "posts",
  Actions: []moleculer.Action{
    {
      Name:  "get",
      Handler: func addAction(ctx moleculer.Context, params moleculer.Payload) interface{} {
        // Find a post by ID
        postId := params.Get("id").String()
        posts := <-ctx.Call("posts.find", map[string]interface{}{
            "query": map[string]interface{}{
                "id": postId,
            },
        })
        post := posts.First()
        // Populate the post.author field through "users" service
        // Call the "users.get" action with author ID
        users := <-ctx.call("users.find", map[string]interface{}{
            "query": map[string]interface{}{
                "id": post.Get("authorId"),
            },
        })
        user := users.First()
        if user.Exists() {
            // Replace the author ID with the received user object
            post.Add("author", user)
        }
        return post
      },
    },
  },
}
```

## Events

You can subscribe to events under the `events` key.

```go
moleculer.ServiceSchema{
  Name: "report",
  Events: []moleculer.Event{

  events: {
    // Subscribe to "user.created" event
    "user.created"(payload) {
      this.logger.info("User created:", payload);
      // Do something
    },

    // Subscribe to all "user.*" event
    "user.*"(payload, sender, eventName) {
      // Do something with payload. The `eventName` contains
      // the original event name. E.g. `user.modified`.
      // The `sender` is the nodeID of sender.
    }

    // Subscribe to a local event
    "$node.connected"({ node }) {
      this.logger.info(`Node '${node.id}' is connected!`);
    }
  }
};
```

> In handlers the `this` is always pointed to the Service instance.

### Grouping

The broker groups the event listeners by group name. By default, the group name is the service name. But you can overwrite it in the event definition.

```js
module.exports = {
    name: "payment",
    events: {
        "order.created": {
            // Register handler to the "other" group instead of "payment" group.
            group: "other",
            handler(payload) {
                // ...
            }
        }
    }
};
```

## Methods

To create private methods in the service, put your functions under the `methods` key. These functions are private, can't be called with `broker.call`. But you can call it inside service (from action handlers, event handlers and lifecycle event handlers).

**Usage**

```js
module.exports = {
  name: "mailer",
  actions: {
    send(ctx) {
      // Call the `sendMail` method
      return this.sendMail(ctx.params.recipients, ctx.params.subject, ctx.params.body);
    }
  },

  methods: {
    // Send an email to recipients
    sendMail(recipients, subject, body) {
      return new Promise((resolve, reject) => {
        ...
      });
    }
  }
};
```

> The method name can't be `name`, `version`, `settings`, `schema`, `broker`, `actions`, `logger`, because these words are reserved in the schema.

> In methods the `this` is always pointed to the Service instance.

## Lifecycle events

There are some lifecycle service events, that will be triggered by broker. They are placed in the root of schema.

```js
module.exports = {
  name: "www",
  actions: {...},
  events: {...},
  methods: {...},

  created() {
    // Fired when the service instance created (with `broker.loadService` or `broker.createService`)
  },

  async started() {
    // Fired when broker starts this service (in `broker.start()`)
  }

  async stopped() {
    // Fired when broker stops this service (in `broker.stop()`)
  }
};
```

## Dependencies

If your service depends on other services, use the `dependencies` property in the schema. The service waits for dependent services before calls the `started` lifecycle event handler.

```js
module.exports = {
  name: "posts",
  settings: {
    $dependencyTimeout: 30000 // Default: 0 - no timeout
  },
  dependencies: [
    "likes", // shorthand w/o version
    { name: "users", version: 2 }, // with numeric version
    { name: "comments", version: "staging" } // with string version
  ],
  async started() {
    this.logger.info("It will be called after all dependent services are available.");
    const users = await this.broker.call("users.list");
  }
  ....
}
```

The `started` service handler is called once the `likes`, `users` and `comments` services are available (either the local or remote nodes).

### Wait for services via ServiceBroker

To wait for services, you can also use the `waitForServices` method of `ServiceBroker`. It returns a `Promise` which will be resolved, when all defined services are available & started.

**Parameters**

| Parameter  | Type                | Default | Description                                                                                   |
| ---------- | ------------------- | ------- | --------------------------------------------------------------------------------------------- |
| `services` | `String` or `Array` | -       | Service list to waiting                                                                       |
| `timeout`  | `Number`            | `0`     | Waiting timeout. `0` means no timeout. If reached, a `MoleculerServerError` will be rejected. |
| `interval` | `Number`            | `1000`  | Frequency of watches in milliseconds                                                          |

**Example**

```js
broker.waitForServices(["posts", "users"]).then(() => {
    // Called after the `posts` & `users` services are available
});
```

**Set timeout & interval**

```js
broker
    .waitForServices("accounts", 10 * 1000, 500)
    .then(() => {
        // Called if `accounts` service becomes available in 10 seconds
    })
    .catch(err => {
        // Called if service is not available in 10 seconds
    });
```

**Versioned services**

```js
await broker.waitForServices([
    { name: "posts", version: 2 },
    { name: "users" }
]);
```

## Metadata

The `Service` schema has a `metadata` property. You can store here any meta information about service. You can access it as `this.metadata` inside service functions.
_Moleculer core modules don't use it. You can store it whatever you want._

```js
module.exports = {
  name: "posts",
  settings: {},
  metadata: {
    scalable: true,
    priority: 5
  },

  actions: { ... }
};
```

> The `metadata` is also obtainable on remote nodes. It is transferred during service discovering.

## Properties of Service instances

In service functions, `this` is always pointed to the Service instance. It has some properties & methods what you can use in your service functions.

| Name                   | Type                 | Description                                                              |
| ---------------------- | -------------------- | ------------------------------------------------------------------------ |
| `this.name`            | `String`             | Name of service (from schema)                                            |
| `this.version`         | `Number` or `String` | Version of service (from schema)                                         |
| `this.settings`        | `Object`             | Settings of service (from schema)                                        |
| `this.metadata`        | `Object`             | Metadata of service (from schema)                                        |
| `this.schema`          | `Object`             | Schema definition of service                                             |
| `this.broker`          | `ServiceBroker`      | Instance of broker                                                       |
| `this.Promise`         | `Promise`            | Class of Promise (Bluebird)                                              |
| `this.logger`          | `Logger`             | Logger instance                                                          |
| `this.actions`         | `Object`             | Actions of service. _Service can call own actions directly_              |
| `this.waitForServices` | `Function`           | Link to ['broker.waitForServices' method](broker.html#Wait-for-services) |

## Create a service

There are several ways to create and load a service.

### broker.createService()

For testing, developing or prototyping, use the `broker.createService` method to load & create a service by schema. It's simplest & fastest.

```js
broker.createService({
    name: "math",
    actions: {
        add(ctx) {
            return Number(ctx.params.a) + Number(ctx.params.b);
        }
    }
});
```

### Load service from file

The recommended way is to place your service code into a single file and load it with the broker.

**math.service.js**

```js
// Export the schema of service
module.exports = {
    name: "math",
    actions: {
        add(ctx) {
            return Number(ctx.params.a) + Number(ctx.params.b);
        },
        sub(ctx) {
            return Number(ctx.params.a) - Number(ctx.params.b);
        }
    }
};
```

**Load it with broker:**

```js
// Create broker
const broker = new ServiceBroker();

// Load service
broker.loadService("./math.service");

// Start broker
broker.start();
```

In the service file you can also create the Service instance. In this case, you have to export a function which returns the instance of [Service](#service).

```js
const { Service } = require("moleculer");

// Export a function, the `loadService` will call it with the ServiceBroker instance.
module.exports = function(broker) {
    return new Service(broker, {
        name: "math",
        actions: {
            add(ctx) {
                return Number(ctx.params.a) + Number(ctx.params.b);
            },
            sub(ctx) {
                return Number(ctx.params.a) - Number(ctx.params.b);
            }
        }
    });
};
```

Or create a function which returns with the schema of service

```js
// Export a function, the `loadService` will call with the ServiceBroker instance.
module.exports = function() {
  let users = [....];

  return {
    name: "math",
    actions: {
      create(ctx) {
        users.push(ctx.params);
      }
    }
  };
}
```

### Load multiple services from a folder

If you have many services (and you will have) we suggest to put them to a `services` folder and load all of them with the `broker.loadServices` method.

**Syntax**

```js
broker.loadServices((folder = "./services"), (fileMask = "**/*.service.js"));
```

**Example**

```js
// Load every *.service.js file from the "./services" folder (including subfolders)
broker.loadServices();

// Load every *.service.js file from the current folder (including subfolders)
broker.loadServices("./");

// Load every user*.service.js file from the "./svc" folder
broker.loadServices("./svc", "user*.service.js");
```

### Load with Moleculer Runner (recommended)

We recommend to use the [Moleculer Runner](runner.html) to start a ServiceBroker and load services. [Read more about Moleculer Runner](runner.html). It is the easiest way to start a node.

## Hot reloading services

Moleculer has a built-in hot-reloading function. During development, it can be very useful because it reloads your services when you modify it. You can enable it in broker options or in [Moleculer Runner](runner.html).
[Demo video how it works.](https://www.youtube.com/watch?v=l9FsAvje4F4)

**Enable in broker options**

```js
const broker = new ServiceBroker({
    hotReload: true
});

broker.loadService("./services/test.service.js");
```

**Enable it in Moleculer Runner**

Turn it on with `--hot` or `-H` flags.

```bash
$ moleculer-runner --hot ./services/test.service.js
```

{% note info %}
Hot reloading function is working only with Moleculer Runner or if you load your services with `broker.loadService` or `broker.loadServices`. It doesn't work with `broker.createService`.
{% endnote %}

{% note info %}
Hot reloading watches only the `service.js` file. If you are using additional JS files in your services and they are changed, broker won't detect it. In this case it is better to use [nodemon](https://github.com/remy/nodemon) to restart all services and broker.
{% endnote %}

## Local variables

If you would like to use local properties/variables in your service, declare them in the `created` event handler.

**Example for local variables**

```js
const http = require("http");

module.exports = {
  name: "www",

  settings: {
    port: 3000
  },

  created() {
    // Create HTTP server
    this.server = http.createServer(this.httpHandler);
  },

  started() {
    // Listening...
    this.server.listen(this.settings.port);
  },

  stopped() {
    // Stop server
    this.server.close();
  },

  methods() {
    // HTTP handler
    httpHandler(req, res) {
      res.end("Hello Moleculer!");
    }
  }
}
```

{% note warn Naming restriction %}
It is important to be aware that you can't use variable name which is reserved for service or coincides with your method names! E.g. `this.name`, `this.version`, `this.settings`, `this.schema`...etc.  
{% endnote %}

## ES6 classes

If you like better ES6 classes than Moleculer service schema, you can write your services in ES6 classes. There are two ways to do it.

### Native ES6 classes with schema parsing

Define `actions` and `events` handlers as class methods and call the `parseServiceSchema` method in constructor with schema definition where the handlers pointed to these class methods.

```js
const Service = require("moleculer").Service;

class GreeterService extends Service {
    constructor(broker) {
        super(broker);

        this.parseServiceSchema({
            name: "greeter",
            version: "v2",
            meta: {
                scalable: true
            },
            dependencies: ["auth", "users"],

            settings: {
                upperCase: true
            },
            actions: {
                hello: this.hello,
                welcome: {
                    cache: {
                        keys: ["name"]
                    },
                    params: {
                        name: "string"
                    },
                    handler: this.welcome
                }
            },
            events: {
                "user.created": this.userCreated
            },
            created: this.serviceCreated,
            started: this.serviceStarted,
            stopped: this.serviceStopped
        });
    }

    // Action handler
    hello() {
        return "Hello Moleculer";
    }

    // Action handler
    welcome(ctx) {
        return this.sayWelcome(ctx.params.name);
    }

    // Private method
    sayWelcome(name) {
        this.logger.info("Say hello to", name);
        return `Welcome, ${
            this.settings.upperCase ? name.toUpperCase() : name
        }`;
    }

    // Event handler
    userCreated(user) {
        this.broker.call("mail.send", { user });
    }

    serviceCreated() {
        this.logger.info("ES6 Service created.");
    }

    serviceStarted() {
        this.logger.info("ES6 Service started.");
    }

    serviceStopped() {
        this.logger.info("ES6 Service stopped.");
    }
}

module.exports = GreeterService;
```

### Use decorators

Thanks for [@ColonelBundy](https://github.com/ColonelBundy), you can use ES7/TS decorators as well: [moleculer-decorators](https://github.com/ColonelBundy/moleculer-decorators)

{% note info Need a compiler %}
Please note, you must use Typescript or Babel to compile decorators.
{% endnote %}

**Example service**

```js
const { ServiceBroker } = require("moleculer");
const { Service, Action, Event, Method } = require("moleculer-decorators");
const web = require("moleculer-web");
const broker = new ServiceBroker();

@Service({
    mixins: [web],
    settings: {
        port: 3000,
        routes: [
            //...
        ]
    }
})
class MyService {
    @Action()
    Login(ctx) {
        //...
    }

    // With options
    @Action({
        cache: false,
        params: {
            a: "number",
            b: "number"
        }
    })
    Login2(ctx) {
        //...
    }

    @Event
    "event.name"(payload, sender, eventName) {
        //...
    }

    @Method
    authorize(ctx, route, req, res) {
        //...
    }

    hello() {
        // Private
        //...
    }

    started() {
        // Reserved for moleculer, fired when started
        //...
    }

    created() {
        // Reserved for moleculer, fired when created
        //...
    }

    stopped() {
        // Reserved for moleculer, fired when stopped
        //...
    }
}

broker.createService(MyService);
broker.start();
```

## Internal services

The `ServiceBroker` contains some internal services to check the node health or get some registry informations. You can disable to load them with the `internalServices: false` broker option.

### List of nodes

It lists all known nodes (including local node).

```js
broker.call("$node.list").then(res => console.log(res));
```

**Parameters**

| Name            | Type      | Default | Description                |
| --------------- | --------- | ------- | -------------------------- |
| `withServices`  | `Boolean` | `false` | List with services.        |
| `onlyAvailable` | `Boolean` | `false` | List only available nodes. |

### List of services

It lists all registered services (local & remote).

```js
broker.call("$node.services").then(res => console.log(res));
```

**Parameters**

| Name            | Type      | Default | Description                           |
| --------------- | --------- | ------- | ------------------------------------- |
| `onlyLocal`     | `Boolean` | `false` | List only local services.             |
| `skipInternal`  | `Boolean` | `false` | Skip the internal services (`$node`). |
| `withActions`   | `Boolean` | `false` | List with actions.                    |
| `onlyAvailable` | `Boolean` | `false` | List only available services.         |

### List of local actions

It lists all registered actions (local & remote).

```js
broker.call("$node.actions").then(res => console.log(res));
```

It has some options which you can declare within `params`.

**Options**

| Name            | Type      | Default | Description                          |
| --------------- | --------- | ------- | ------------------------------------ |
| `onlyLocal`     | `Boolean` | `false` | List only local actions.             |
| `skipInternal`  | `Boolean` | `false` | Skip the internal actions (`$node`). |
| `withEndpoints` | `Boolean` | `false` | List with endpoints _(nodes)_.       |
| `onlyAvailable` | `Boolean` | `false` | List only available actions.         |

### List of local events

It lists all event subscriptions.

```js
broker.call("$node.events").then(res => console.log(res));
```

It has some options which you can declare within `params`.

**Options**

| Name            | Type      | Default | Description                                |
| --------------- | --------- | ------- | ------------------------------------------ |
| `onlyLocal`     | `Boolean` | `false` | List only local subscriptions.             |
| `skipInternal`  | `Boolean` | `false` | Skip the internal event subscriptions `$`. |
| `withEndpoints` | `Boolean` | `false` | List with endpoints _(nodes)_.             |
| `onlyAvailable` | `Boolean` | `false` | List only available subscriptions.         |

### Health of node

It returns the health info of local node (including process & OS information).

```js
broker.call("$node.health").then(res => console.log(res));
```

Example health info:

```js
{
  "cpu": {
    "load1": 0,
    "load5": 0,
    "load15": 0,
    "cores": 4,
    "utilization": 0
  },
  "mem": {
    "free": 1217519616,
    "total": 17161699328,
    "percent": 7.094400109979598
  },
  "os": {
    "uptime": 366733.2786046,
    "type": "Windows_NT",
    "release": "6.1.7601",
    "hostname": "Developer-PC",
    "arch": "x64",
    "platform": "win32",
    "user": {
      "uid": -1,
      "gid": -1,
      "username": "Developer",
      "homedir": "C:\\Users\\Developer",
      "shell": null
    }
  },
  "process": {
    "pid": 13096,
    "memory": {
      "rss": 47173632,
      "heapTotal": 31006720,
      "heapUsed": 22112024
    },
    "uptime": 25.447
  },
  "client": {
    "type": "nodejs",
    "version": "0.12.0",
    "langVersion": "v8.9.4"
  },
  "net": {
    "ip": [
      "192.168.2.100",
      "192.168.232.1",
      "192.168.130.1",
      "192.168.56.1",
      "192.168.99.1"
    ]
  },
  "time": {
    "now": 1487338958409,
    "iso": "2018-02-17T13:42:38.409Z",
    "utc": "Fri, 17 Feb 2018 13:42:38 GMT"
  }
}
```
