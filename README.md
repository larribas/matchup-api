# Matchup API [![Build Status](https://semaphoreci.com/api/v1/larribas/matchup-api/branches/master/badge.svg)](https://semaphoreci.com/larribas/matchup-api)


_Matchup_ is an application that connects people who want to do something together (whether it is grabbing a beer, having lunch or playing a sport match).

It is conceived as a simple real-time application that allows you to create plans with certain characteristics and subscribe to other plans you may be interested in. The application notifies you whenever the plan is complete.


## Technical POV

_Matchup_ is written in [Elixir](http://elixir-lang.org/) and exposes a WebSocket protocol to execute use cases and listen to new events in real time.

Each event has its own nature (its own properties and rules). The application can be configured to use different "behaviors" or "logics" for different types of plans. Thus, it is flexible and extensible enough to control things as diverse as:

* Dinners with a maximum number of attendees
* Football matches with both a minimum and a maximum number of players
* Table soccer matches that use a single table (and have to start when the previous event of that type finishes)
* And so on...


## Roadmap

1. [x] Set up application structure
1. [x] Expose dummy WebSocket API
1. [x] Implement table soccer logic
1. [x] Allow switchable logics that handle arbitrary use cases and events
1. [x] Allow configuring the logics depending on user input, using pattern matching
1. [x] Deploy application with Docker
1. [x] Wire to CI environment
1. [x] Use MongoDB to persist events in repositories
1. [ ] Use supervision and concurrency to serve multiple clients fast and reliably
1. [ ] Launch together with a cool frontend!
1. [ ] Offer integration with Slack to:
  1.1. [ ] Access the API and create events (chatbot)
  1.2. [ ] Notify and remind people when an event is complete and about to start



## Development

To start the Matchup API and all its dependencies, run `docker-compose up`

You can find the HTTP API at [`localhost:4000/api`](http://localhost:4000/api) and the WebSocket API at [`localhost:4000/socket`](http://localhost:4000/socket).