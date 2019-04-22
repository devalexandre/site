# Logging

---

Moleculer uses [`logrus`](https://github.com/sirupsen/logrus) as its logger component.

These loggers can be tagged with attributes to make it easy to filter and find log messages.

Moleculer does that internaly, so the logger used in the registry is tagged `registry` for example.

```bash
time="2019-04-21T18:59:02+12:00" level=info msg="Registry - $node service is registered." broker=Node_Zlgip registry="Moleculer Registry"
```

The logger that you can access from the context from within an action hanbdler is tagged with the action name :)

```go
moleculer.ServiceSchema{
  Name: "posts",
  Actions: []moleculer.Action{
    {
      Name:  "get",
      Handler: func addAction(ctx moleculer.Context, params moleculer.Payload) interface{} {
        ctx.Logger().Info("add action was called.. but this information is already in the log :)"})
        // time="2019-04-21T18:59:02+12:00" level=info msg="add action was called.. but this information is already in the log :)" action=posts.get broker=xyzpt
      },
    },
  },
}
```

**Design decisions:**

For the MVP we have not exposed much log configurations, options. Please let us know what your needs are and please also help us by submitting a PR wiht your ideas/suggestions.

We have plans to add plugins to connect moleculer logs with cloud loggins systems like papertrail.
