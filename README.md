WebHooker
=========

WebHooker is a service that provides easy consumption of webhooks from
various providers by routing the incoming webhooks to a dynamically
configured URL on the internet, by logging them, and keeping a track of
their outcomes - whether they were successful or not - and what errors
were thrown.

Features
--------

- [ ] Log the incoming webhook request.
- [ ] Forward it to a dynamically configured URL on the internet.
- [ ] Check the response from the service that receives the webhook, and record it.

Schema
------

- `portal`: entry point for incoming requests that need to be forwarded.
- `destination`: URLs where the incoming requests will be forwarded to.
- `submission`: incoming request for forwarding
- `reply`: response received from a particular `destination`

Associations
------------

- a `portal` has many `destinations`
- a `portal` has many `submissions`
- a `submission` has many `replies`

