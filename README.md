API tester
====

An API tester.

Require browser supports:
* `Promise`
* `fetch`
* arrow functions
* `window.DOMParser`
* `XSLTProcessor`

Required to be deployed on server. Server/s should be configured to support CORS if necessary.

```javascript
// configure api host
testapi.config.setHost("http://host.of.api");
```

If deployed on an api test server (as static resources), api host configuration is not necessary.
