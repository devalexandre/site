# API Gateway

---

The [gateway](https://github.com/moleculer-go/gateway) is the official API gateway service for Moleculer Go.
You can use it to **expose** your services over HTTP as RESTful APIs:

```go
package main

import (
  "fmt"
  "io/ioutil"
  "net/http"

  "github.com/moleculer-go/moleculer"

  "github.com/moleculer-go/gateway"
  "github.com/moleculer-go/moleculer/broker"
)

type UserService struct {
}

func (svc *UserService) Name() string {
  return "user"
}

func (svc *UserService) Greet(params moleculer.Payload) string {
  return "Horay! " + params.Get("name").String() + ", you have called an action using the HTTP gateway!"
}

func main() {
  userSvc := &UserService{}
  gatewaySvc := &gateway.HttpService{
    Settings: map[string]interface{}{"port": "9015"},
    Depends:  []string{"user"},
  }

  bkr := broker.New(&moleculer.Config{LogLevel: "error"})
  bkr.Publish(gatewaySvc, userSvc)
  bkr.Start()

  response, _ := http.Get("http://localhost:9015/user/greet?name=John_Snow")
  // $ Horay! John_Snow, you have called an action using the HTTP gateway!
  fmt.Println(bodyContent(response))

  bkr.Stop()
}

// bodyContent return the response body as string
func bodyContent(resp *http.Response) string {
  defer resp.Body.Close()
  bts, _ := ioutil.ReadAll(resp.Body)
  return string(bts)
}
```

#### run the example above with:

```bash
$ go run github.com/moleculer-go/gateway/examples/simple
# Note: Go 1.11+ required to run a repository like that
# If you have a older version you need to download the code and run locally.
```

You can also listen to your events over WebSockets directly from your browser code :)

## Features

-   support HTTP & HTTPS
-   serve static files
-   reverse proxy for easy development
-   multiple routes
-   alias names (with named parameters & REST routes)
-   whitelist
-   multiple body parsers (json, urlencoded)

## Install

```bash
go get github.com/moleculer-go/gateway
```

## Usage

### Run with default settings

This example uses API Gateway service with default settings.
You can access all services (including internal `$node.`) via `http://localhost:3000/`

```go
const { ServiceBroker } = require("moleculer");
const ApiService = ...

const broker = new ServiceBroker();

// Load API Gateway
broker.createService(ApiService);

// Start server
broker.start();
```

**Example URLs:**

-   Call `test.hello` action: `http://localhost:3000/test/hello`
-   Call `math.add` action with params: `http://localhost:3000/math/add?a=25&b=13`

-   Get health info of node: `http://localhost:3000/~node/health`
-   List all actions: `http://localhost:3000/~node/actions`

## Whitelist

If you don't want to publish all actions, you can filter them with whitelist option.
Use match strings or regexp in list. _To enable all actions, use `"**"` item._

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                path: "/api",

                whitelist: [
                    // Access any actions in 'posts' service
                    "posts.*",
                    // Access call only the `users.list` action
                    "users.list",
                    // Access any actions in 'math' service
                    /^math\.\w+$/
                ]
            }
        ]
    }
});
```

## Aliases

You can use alias names instead of action names. You can also specify the method. Otherwise it will handle every method types.

Using named parameters in aliases is possible. Named parameters are defined by prefixing a colon to the parameter name (`:name`).

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                aliases: {
                    // Call `auth.login` action with `GET /login` or `POST /login`
                    login: "auth.login",

                    // Restrict the request method
                    "POST users": "users.create",

                    // The `name` comes from named param.
                    // You can access it with `ctx.params.name` in action
                    "GET greeter/:name": "test.greeter"
                }
            }
        ]
    }
});
```

{% note info %}
The named parameter is handled with [path-to-regexp](https://github.com/pillarjs/path-to-regexp) module. Therefore you can use [optional](https://github.com/pillarjs/path-to-regexp#optional) and [repeated](https://github.com/pillarjs/path-to-regexp#zero-or-more) parameters, as well.
{% endnote %}

You can also create RESTful APIs.

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                aliases: {
                    "GET users": "users.list",
                    "GET users/:id": "users.get",
                    "POST users": "users.create",
                    "PUT users/:id": "users.update",
                    "DELETE users/:id": "users.remove"
                }
            }
        ]
    }
});
```

For REST routes you can also use this simple shorthand alias:

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                aliases: {
                    "REST users": "users"
                }
            }
        ]
    }
});
```

{% note warn %}
To use this shorthand alias, create a service which has `list`, `get`, `create`, `update` and `remove` actions.
{% endnote %}

You can make use of custom functions within the declaration of aliases.

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                aliases: {
                    "POST upload"(req, res) {
                        this.parseUploadedFile(req, res);
                    }
                }
            }
        ]
    }
});
```

{% note info %}
There are some internal pointer in `req` & `res` objects:

-   `req.$ctx` are pointed to request context.
-   `req.$service` & `res.$service` are pointed to this service instance.
-   `req.$route` & `res.$route` are pointed to the resolved route definition.
-   `req.$params` is pointed to the resolved parameters (from query string & post body)
-   `req.$alias` is pointed to the resolved alias definition.
-   `req.$action` is pointed to the resolved action.
-   `req.$endpoint` is pointed to the resolved action endpoint.
-   `req.$next` is pointed to the `next()` handler if the request comes from ExpressJS.

E.g.: To access the broker, use `req.$service.broker`.
{% endnote %}

### Mapping policy

The `route` has a `mappingPolicy` property to handle routes without aliases.

**Available options:**

-   `all` - enable to request all routes with or without aliases (default)
-   `restrict` - enable to request only the routes with aliases.

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                mappingPolicy: "restrict",
                aliases: {
                    "POST add": "math.add"
                }
            }
        ]
    }
});
```

You can't request the `/math.add` or `/math/add` URLs, only `POST /add`.

## Parameters

API gateway collects parameters from URL querystring, request params & request body and merges them. The results is placed to the `req.$params`.

### Disable merging

To disable parameter merging set `mergeParams: false` in route settings. In this case the parameters is separated.

**Example**

```js
broker.createService({
    mixins: [ApiService],
    settings: {
        routes: [
            {
                path: "/",
                mergeParams: false
            }
        ]
    }
});
```

**Un-merged `req.$params`:**

```js
{
    // Querystring params
    query: {
        category: "general",
    }

    // Request body content
    body: {
        # "Hello",
        content: "...",
        createdAt: 1530796920203
    },

    // Request params
    params: {
        id: 5
    }
}
```

### Query string parameters

More information: https://github.com/ljharb/qs

**Array parameters**
URL: `GET /api/opt-test?a=1&a=2`

```js
a: ["1", "2"];
```

**Nested objects & arrays**
URL: `GET /api/opt-test?foo[bar]=a&foo[bar]=b&foo[baz]=c`

```js
foo: {
    bar: ["a", "b"],
    baz: "c"
}
```

## Middlewares

It supports Connect-like middlewares in global-level, route-level & alias-level. Signature: `function(req, res, next) {...}`.

**Example**

```js
broker.createService({
    mixins: [ApiService],
    settings: {
        // Global middlewares. Applied to all routes.
        use: [cookieParser(), helmet()],

        routes: [
            {
                path: "/",

                // Route-level middlewares.
                use: [
                    compression(),

                    passport.initialize(),
                    passport.session(),

                    serveStatic(path.join(__dirname, "public"))
                ],

                aliases: {
                    "GET /secret": [
                        // Alias-level middlewares.
                        auth.isAuthenticated(),
                        auth.hasRole("admin"),
                        "top.secret" // Call the `top.secret` action
                    ]
                }
            }
        ]
    }
});
```

### Error-handler middleware

There is support to use error-handler middlewares in the API Gateway. So if you pass an `Error` to the `next(err)` function, it will call error handler middlewares which have signature as `(err, req, res, next)`.

```js
broker.createService({
    mixins: [ApiService],
    settings: {
        // Global middlewares. Applied to all routes.
        use: [
            cookieParser(),
            helmet()
        ],

        routes: [
            {
                path: "/",

                // Route-level middlewares.
                use: [
                    compression(),

                    passport.initialize(),
                    passport.session(),

                    function(err, req, res, next) {
                        this.logger.error("Error is occured in middlewares!");
                        this.sendError(req, res, err);
                    }
                ],
```

## Serve static files

It serves assets with the [serve-static](https://github.com/expressjs/serve-static) module like ExpressJS.

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        assets: {
            // Root folder of assets
            folder: "./assets",

            // Further options to `server-static` module
            options: {}
        }
    }
});
```

## Calling options

The `route` has a `callOptions` property which is passed to `broker.call`. So you can set `timeout`, `retries` or `fallbackResponse` options for routes. [Read more about calling options](actions.html#Call-services)

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [{

            callOptions: {
                timeout: 500,
                retries: 3,
                fallbackResponse(ctx, err) { ... }
            }

        }]
    }
});
```

## Multiple routes

You can create multiple routes with different prefix, whitelist, alias, calling options & authorization.

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                path: "/admin",

                authorization: true,

                whitelist: ["$node.*", "users.*"]
            },
            {
                path: "/",

                whitelist: ["posts.*", "math.*"]
            }
        ]
    }
});
```

## Response type & status code

When the response is received from an action handler, the API gateway detects the type of response and set the `Content-Type` in the `res` headers. The status code is `200` by default. Of course you can overwrite these values, moreover, you can define custom response headers, too.

To define response headers & status code use `ctx.meta` fields:

**Available meta fields:**

-   `ctx.meta.$statusCode` - set `res.statusCode`.
-   `ctx.meta.$statusMessage` - set `res.statusMessage`.
-   `ctx.meta.$responseType` - set `Content-Type` in header.
-   `ctx.meta.$responseHeaders` - set all keys in header.
-   `ctx.meta.$location` - set `Location` key in header for redirects.

**Example**

```js
module.exports = {
    name: "export",
    actions: {
        // Download response as a file in the browser
        downloadCSV(ctx) {
            ctx.meta.$responseType = "text/csv";
            ctx.meta.$responseHeaders = {
                "Content-Disposition": `attachment; filename="data-${ctx.params.id}.csv"`
            };

            return csvFileStream;
        }

        // Redirect the request
        redirectSample(ctx) {
            ctx.meta.$statusCode = 302;
            ctx.meta.$location = "/login";

            return;
        }
    }
}
```

## Authorization

You can implement authorization. Do 2 things to enable it.

1. Set `authorization: true` in your routes
2. Define the `authorize` method in service.

**Example authorization**

```js
const E = ...

broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [{
            // First thing
            authorization: true
        }]
    },

    methods: {
        // Second thing
        authorize(ctx, route, req, res) {
            // Read the token from header
            let auth = req.headers["authorization"];
            if (auth && auth.startsWith("Bearer")) {
                let token = auth.slice(7);

                // Check the token
                if (token == "123456") {
                    // Set the authorized user entity to `ctx.meta`
                    ctx.meta.user = { id: 1, name: "John Doe" };
                    return Promise.resolve(ctx);

                } else {
                    // Invalid token
                    return Promise.reject(new E.UnAuthorizedError(E.ERR_INVALID_TOKEN));
                }

            } else {
                // No token
                return Promise.reject(new E.UnAuthorizedError(E.ERR_NO_TOKEN));
            }
        }

    }
}
```

{% note info %}
You can find a more detailed role-based JWT authorization example in [full example](https://github.com/ moleculer-go/gateway/blob/master/examples/full/index.js#L239).
{% endnote %}

## Authentication

To enable the support for authentication, you need to do something similar to what is describe in the Authorization paragraph. Also in this case you have to:

1. Set `authentication: true` in your routes
2. Define your custom `authenticate` method in your service

**Example authentication**

```js
broker.createService({
    mixins: ApiGatewayService,

    settings: {
        routes: [
            {
                // Enable authentication
                authentication: true
            }
        ]
    },

    methods: {
        authenticate(ctx, route, req, res) {
            let accessToken = req.query["access_token"];
            if (accessToken) {
                if (accessToken === "12345") {
                    // valid credentials
                    return Promise.resolve({
                        id: 1,
                        username: "john.doe",
                        name: "John Doe"
                    });
                } else {
                    // invalid credentials
                    return Promise.reject();
                }
            } else {
                // anonymous user
                return Promise.resolve(null);
            }
        }
    }
});
```

## Route hooks

The `route` has before & after call hooks. You can use it to set `ctx.meta`, access `req.headers` or modify the response `data`.

```js
broker.createService({
    mixins: [ApiService],

    settings: {
        routes: [
            {
                path: "/",

                onBeforeCall(ctx, route, req, res) {
                    // Set request headers to context meta
                    ctx.meta.userAgent = req.headers["user-agent"];
                },

                onAfterCall(ctx, route, req, res, data) {
                    // Async function which return with Promise
                    return doSomething(ctx, res, data);
                }
            }
        ]
    }
});
```

> In previous versions of Moleculer Web, you couldn't manipulate the `data` in `onAfterCall`. Now you can, but you must always return the new or original `data`.

## Error handlers

You can add route-level & global-level custom error handlers.

> In handlers, you must call the `res.end`. Otherwise, the request is unhandled.

```js
broker.createService({
    mixins: [ApiService],
    settings: {

        routes: [{
            path: "/api",

            // Route error handler
            onError(req, res, err) {
                res.setHeader("Content-Type", "application/json; charset=utf-8");
                res.writeHead(500);
                res.end(JSON.stringify(err));
            }
        }],

        // Global error handler
        onError(req, res, err) {
            res.setHeader("Content-Type", "text/plain");
            res.writeHead(501);
            res.end("Global error: " + err.message);
        }
    }
}
```

## CORS headers

You can use [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) headers in gateway service.

**Usage**

```js
const svc = broker.createService({
    mixins: [ApiService],

    settings: {
        // Global CORS settings for all routes
        cors: {
            // Configures the Access-Control-Allow-Origin CORS header.
            origin: "*",
            // Configures the Access-Control-Allow-Methods CORS header.
            methods: ["GET", "OPTIONS", "POST", "PUT", "DELETE"],
            // Configures the Access-Control-Allow-Headers CORS header.
            allowedHeaders: [],
            // Configures the Access-Control-Expose-Headers CORS header.
            exposedHeaders: [],
            // Configures the Access-Control-Allow-Credentials CORS header.
            credentials: false,
            // Configures the Access-Control-Max-Age CORS header.
            maxAge: 3600
        },

        routes: [
            {
                path: "/api",

                // Route CORS settings (overwrite global settings)
                cors: {
                    origin: ["http://localhost:3000", "https://localhost:4000"],
                    methods: ["GET", "OPTIONS", "POST"],
                    credentials: true
                }
            }
        ]
    }
});
```

## Rate limiter

Built-in rate limiter with a memory store.

**Usage**

```js
const svc = broker.createService({
    mixins: [ApiService],

    settings: {
        rateLimit: {
            // How long to keep record of requests in memory (in milliseconds).
            // Defaults to 60000 (1 min)
            window: 60 * 1000,

            // Max number of requests during window. Defaults to 30
            limit: 30,

            // Set rate limit headers to response. Defaults to false
            headers: true,

            // Function used to generate keys. Defaults to:
            key: req => {
                return (
                    req.headers["x-forwarded-for"] ||
                    req.connection.remoteAddress ||
                    req.socket.remoteAddress ||
                    req.connection.socket.remoteAddress
                );
            }
            //StoreFactory: CustomStore
        }
    }
});
```

### Custom Store example

```js
class CustomStore {
    constructor(window, opts) {
        this.hits = new Map();
        this.resetTime = Date.now() + clearPeriod;

        setInterval(() => {
            this.resetTime = Date.now() + clearPeriod;
            this.reset();
        }, clearPeriod);
    }

    /**
     * Increment the counter by key
     *
     * @param {String} key
     * @returns {Number}
     */
    inc(key) {
        let counter = this.hits.get(key) || 0;
        counter++;
        this.hits.set(key, counter);
        return counter;
    }

    /**
     * Reset all counters
     */
    reset() {
        this.hits.clear();
    }
}
```

## Full service settings

List of all settings of Moleculer Web service:

```js
settings: {

    // Exposed port
    port: 3000,

    // Exposed IP
    ip: "0.0.0.0",

    // HTTPS server with certificate
    https: {
        key: fs.readFileSync("ssl/key.pem"),
        cert: fs.readFileSync("ssl/cert.pem")
    },

    // Middleware mode (for ExpressJS)
    middleware: false,

    // Exposed global path prefix
    path: "/api",

    // Global-level middlewares
    use: [
        compression(),
        cookieParser()
    ],

    // Logging request parameters with 'info' level
    logRequestParams: "info",

    // Logging response data with 'debug' level
    logResponseData: "debug"

    // Routes
    routes: [
        {
            // Path prefix to this route  (full path: /api/admin )
            path: "/admin",

            // Whitelist of actions (array of string mask or regex)
            whitelist: [
                "users.get",
                "$node.*"
            ],

            // Call the `this.authorize` method before call the action
            authorization: true,

            // Merge parameters from querystring, request params & body
            mergeParams: true,

            // Route-level middlewares
            uses: [
                helmet(),
                passport.initialize()
            ],

            // Action aliases
            aliases: {
                "POST users": "users.create",
                "health": "$node.health"
            },

            mappingPolicy: "all",

            // Use bodyparser module
            bodyParsers: {
                json: true,
                urlencoded: { extended: true }
            }
        },
        {
            // Path prefix to this route  (full path: /api )
            path: "",

            // Whitelist of actions (array of string mask or regex)
            whitelist: [
                "posts.*",
                "file.*",
                /^math\.\w+$/
            ],

            // No authorization
            authorization: false,

            // Action aliases
            aliases: {
                "add": "math.add",
                "GET sub": "math.sub",
                "POST divide": "math.div",
                "GET greeter/:name": "test.greeter",
                "GET /": "test.hello",
                "POST upload"(req, res) {
                    this.parseUploadedFile(req, res);
                }
            },

            mappingPolicy: "restrict",

            // Use bodyparser module
            bodyParsers: {
                json: false,
                urlencoded: { extended: true }
            },

            // Calling options
            callOptions: {
                timeout: 3000,
                retries: 3,
                fallbackResponse: "Static fallback response"
            },

            // Call before `broker.call`
            onBeforeCall(ctx, route, req, res) {
                ctx.meta.userAgent = req.headers["user-agent"];
            },

            // Call after `broker.call` and before send back the response
            onAfterCall(ctx, route, req, res, data) {
                res.setHeader("X-Custom-Header", "123456");
            },

            // Route error handler
            onError(req, res, err) {
                res.setHeader("Content-Type", "text/plain");
                res.writeHead(err.code || 500);
                res.end("Route error: " + err.message);
            }
        }
    ],

    // Folder to server assets (static files)
    assets: {
        // Root folder of assets
        folder: "./examples/www/assets",

        // Options to `server-static` module
        options: {}
    },

    // Global error handler
    onError(req, res, err) {
        res.setHeader("Content-Type", "text/plain");
        res.writeHead(err.code || 500);
        res.end("Global error: " + err.message);
    }
}
```

## Examples

-   [Simple](https://github.com/ moleculer-go/gateway/blob/master/examples/simple/index.js)

    -   simple gateway with default settings.

-   [SSL server](https://github.com/ moleculer-go/gateway/blob/master/examples/ssl/index.js)

    -   open HTTPS server
    -   whitelist handling

-   [WWW with assets](https://github.com/ moleculer-go/gateway/blob/master/examples/www/index.js)

    -   serve static files from the `assets` folder
    -   whitelist
    -   aliases
    -   multiple body-parsers

-   [Authorization](https://github.com/ moleculer-go/gateway/blob/master/examples/authorization/index.js)

    -   simple authorization demo
    -   set the authorized user to `Context.meta`

-   [REST](https://github.com/ moleculer-go/gateway/blob/master/examples/rest/index.js)

    -   simple server with RESTful aliases
    -   example `posts` service with CRUD actions

-   [Socket.io](https://github.com/ moleculer-go/gateway/blob/master/examples/socket.io/index.js)
    -   start socket.io websocket server
    -   call action and send back the response via websocket
    -   send Moleculer events to the browser via websocket
-   [Full](https://github.com/ moleculer-go/gateway/blob/master/examples/full/index.js)

    -   SSL
    -   static files
    -   middlewares
    -   multiple routes with different roles
    -   role-based authorization with JWT
    -   whitelist
    -   aliases with named params
    -   multiple body-parsers
    -   before & after hooks
    -   metrics, statistics & validation from Moleculer
    -   custom error handlers

-   [Webpack](https://github.com/ moleculer-go/gateway/blob/master/examples/webpack)

    -   Webpack development environment for client-side developing
    -   webpack config file
    -   compression
    -   static file serving

-   [Webpack-Vue](https://github.com/ moleculer-go/gateway/blob/master/examples/webpack-vue)
    -   Webpack+Vue development environment for VueJS client developing
    -   webpack config file
    -   Hot-replacement
    -   Babel, SASS, SCSS, Vue SFC
