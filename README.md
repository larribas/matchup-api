# Matchup API

_Matchup_ is an application that connects people that want to do something together (whether it is grabbing a beer, having lunch somewhere or playing a sport match).

It is conceived as a simple real-time application that allows you to create events with certain characteristics and subscribe to other events you may be interested in. The application notifies you whenever the event is complete.


## Technical POV

_Matchup_ is written in [Elixir](http://elixir-lang.org/) and exposes an API using the WebSocket protocol. This API allows you to:

* Create a new event
* Search current and past events
* Subscribe to an ongoing event
* Unsubscribe from an ongoing event

Each event has its own nature (its own properties and rules). The application can be configured to use different "behaviors" or "logics" for different types of events. Thus, it is flexible and extensible enough to control things as diverse as:

* Dinners with a maximum number of attendees
* Football matches with both a minimum and a maximum number of players
* Table soccer matches that use a single table (and have to start when the previous event of that type finishes)



## Roadmap

1. [x] Set up application structure
2. [ ] Expose dummy WebSocket API
3. [ ] Allow switchable logics that handle arbitrary commands, queries and events
4. [ ] Implement main logic (`CreateEvent`, `SearchEvents`, `SubscribeToEvent`, `UnsubscribeFromEvent`)
5. [ ] Implement table soccer logic
6. [ ] Allow configuring the logics depending on user input, using pattern matching
7. [ ] Persist events in repositories (use Redis as a first stepping stone)
8. [ ] Deploy application with Docker
9. [ ] Use supervision and concurrency to serve multiple clients fast and reliably
10. [ ] Launch together with a cool frontend!


*Even more ideas for the future:*

* Offer integration with Slack to:
	* Access the API and create events (chatbot)
	* Notify and remind people when an event is complete and about to start



## Development

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.