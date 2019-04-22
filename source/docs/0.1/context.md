# Context

---

{% note info WIP Documentation %}

<img src="assets/under_construction.png" width=150/>

This documentation is still a working in progress and this page has not been fully converted yet :(

We are working on top of the existing Moleculer JS documentation, and that is why you might see pages with some JavaScript :)
{% endnote %}
When you call an action, the broker creates a `Context` instance which contains all request information and passes it to the action handler as a single argument.

**Available properties & methods of `Context`:**

| Name               | Type            | Description                                                      |
| ------------------ | --------------- | ---------------------------------------------------------------- |
| `ctx.id`           | `String`        | Context ID                                                       |
| `ctx.broker`       | `ServiceBroker` | Instance of the broker.                                          |
| `ctx.action`       | `Object`        | Instance of action definition.                                   |
| `ctx.nodeID`       | `String`        | Node ID.                                                         |
| `ctx.requestID`    | `String`        | Request ID. If you make nested-calls, it will be the same ID.    |
| `ctx.parentID`     | `String`        | Parent context ID (in nested-calls).                             |
| `ctx.params`       | `Any`           | Request params. _Second argument from `broker.call`._            |
| `ctx.meta`         | `Any`           | Request metadata. _It will be also transferred to nested-calls._ |
| `ctx.callerNodeID` | `String`        | Caller Node ID if it is requested from a remote node.            |
| `ctx.level`        | `Number`        | Request level (in nested-calls). The first level is `1`.         |
| `ctx.call()`       | `Function`      | You can make a sub-call. Same arguments like `broker.call`       |
| `ctx.emit()`       | `Function`      | Emit an event, like `broker.emit`                                |
| `ctx.broadcast`    | `Function`      | Broadcast an event, like `broker.broadcast`                      |
