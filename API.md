# API Reference

The WebSocket API is exposed on `host:4000/socket`. It leverages [Phoenix's Channels](https://hexdocs.pm/phoenix/Phoenix.Channel.html#summary) to offer an efficient way of subscribing only to those plans you are interested on.

## Types of plans and actions

Each type of plan (e.g. table_soccer, dinner, party, etc.) has particular rules and characteristics. To accomodate this, each type of plan gets its own component, use cases and events.

In order to execute use cases and listen to events about a certain type of plan, subscribe to channel `"plan:{{specific_type}}"`

You can find the available types under `lib/matchup/plans`. Each plan contains all the documentation necessary to use it and extend it.

**Example:**
Imagine in plan `party` there is a use case called `propose` that takes a name and a maximum number of people (max_people) as arguments.

To execute such use case, push the following message to the socket (pseudo code):

```
push socket, "use_case:propose", {name: "New Years Eve 2016", max_people: 100}
```

The parameters have to be transmitted as a JSON object.

This use case will create a new party proposal and:
1. Return the result (in this case, the proposed party) to the client (i.e. push it to the socket)
2. Broadcast a `party_was_proposed` event to all clients listening to that plan, with the appropriate information.

