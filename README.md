# OmiChan

A simple server to interact with the [Bocco Emo Robot](https://www.bocco.me/en/)

## Environment Variables

To be stored in `.env` file in root

* **REFRESH_TOKEN** (required): Obtained through the Bocco Emo API Admin dashboard
* **REFRESH_INTERVAL**: Time interval for token refresh in milliseconds. Must be more than 60000ms (1 minute). Defaults to 3600000ms (1 hour)
* **ROOM_ID**: Emo unit's room id (can be retrieved from API)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/omi_server>.

