# FAQ

---

{% note info WIP Documentation %}

<img src="assets/under_construction.png" width=150/>

This documentation is still a working in progress and this page has not been fully converted yet :(

We are working on top of the existing Moleculer JS documentation, and that is why you might see pages with some JavaScript :)
{% endnote %}

# Core & Common

## How can I start services with Moleculer Runner in debug mode?

Use the following command:

```bash
$ node --inspect=0.0.0.0:9229 node_modules/moleculer/bin/moleculer-runner services
```

# Gateway

## Why am I getting `413 - request entity too large` error message when sending a big POST body

You should configure the `bodyParsers` to overwrite the default `100kb` POST body limit. [More info](https://github.com/expressjs/body-parser#limit).

```js
module.exports = {
    name: "api",
    settings: {
        routes: [
            {
                path: "/api",

                // Use bodyparser modules
                bodyParsers: {
                    json: { limit: "2MB" },
                    urlencoded: { extended: true, limit: "2MB" }
                }
            }
        ]
    }
};
```

{% note info Recommendation %}
Use [streaming feature](https://moleculer.services/docs/0.1/actions.html#Streaming) when you want to send big data to a service or receive from a service.
{% endnote %}
