# Statistics

---

{% note info WIP Documentation %}

<img src="assets/under_construction.png" width=150/>

This documentation is still a working in progress and this page has not been fully converted yet :(

We are working on top of the existing Moleculer JS documentation, and that is why you might see pages with some JavaScript :)
{% endnote %}
Moleculer has a statistics module that collects and aggregates the count & latency info of the requests.
You can enable it in the [broker options](broker.html#Broker-options) with `statistics: true`.
{% note warn %}
The data is stored only in **memory**. If you would like to store it, you have to do it!
You can access the statistics data if you call the internal `$node.stats` action.
{% endnote %}

The result looks like the following:

```js
{
  "requests": {
    // Total statistics
    "total": {

      // Count of requests
      "count": 45,

      // Count of error by code
      "errors": {},

      // Req/sec values
      "rps": {
        "current": 0.7999854548099126,
        // Last x values
        "values": [
          0,
          6.59868026394721,
          2.200440088017604
        ]
      },

      // Request latency values (ms)
      "latency": {
        "mean": 0.8863636363636364,
        "median": 0,
        "90th": 1,
        "95th": 5,
        "99th": 12,
        "99.5th": 12
      }
    },

    // Action-based statistics
    "actions": {
      "posts.find": {
        "count": 4,
        "errors": {},
        "rps": {
          "current": 0.599970001499925,
          "values": [
            1.7985611510791368,
            0.20004000800160032
          ]
        },
        "latency": {
          "mean": 7.5,
          "median": 5,
          "90th": 12,
          "95th": 12,
          "99th": 12,
          "99.5th": 12
        }
      }
    }
  }
}
```
