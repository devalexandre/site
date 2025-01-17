# Circuit breaker

---

{% note info WIP Documentation %}

<img src="assets/under_construction.png" width=150/>

This documentation is still a working in progress and this page has not been fully converted yet :(

We are working on top of the existing Moleculer JS documentation, and that is why you might see pages with some JavaScript :)
{% endnote %}
_Added in: v0.7.6_

The Moleculer has a built-in circuit-breaker solution.
{% note info What is the circuit breaker? %}
Read more about circuit breaker on [Martin Fowler blog](https://martinfowler.com/bliki/CircuitBreaker.html).
{% endnote %}

If you enable it, every service call will be protected by a built-in circuit breaker.

**Enable it in the broker options**

```js
const broker = new ServiceBroker({
    circuitBreaker: {
        enabled: true,
        maxFailures: 5,
        halfOpenTime: 10 * 1000,
        failureOnTimeout: true,
        failureOnReject: true
    }
});
```

## Settings

| Name               | Type      | Default | Description                                                       |
| ------------------ | --------- | ------- | ----------------------------------------------------------------- |
| `enabled`          | `Boolean` | `false` | Enable the protection                                             |
| `maxFailures`      | `3`       | `false` | Breaker trips after 3 failures                                    |
| `halfOpenTime`     | `Number`  | `10000` | Number of milliseconds to switch from `open` to `half-open` state |
| `failureOnTimeout` | `Boolean` | `true`  | Increment failures if the request is timed out                    |
| `failureOnReject`  | `Boolean` | `true`  | Increment failures if the request is rejected (by any `Error`)    |

> If the circuit-breaker state is changed, ServiceBroker will send [internal](broker.html#Internal-events) & [metrics](metrics.html#Circuit-breaker-events) events.
