# Toggl Bexio Syncronisation

The idea of this project is just to have the possibility to take certain toggl time entries and copy them into the swiss software bexio.

This is just a project mainly for myself, as I use Toggl all the time and not always with Bexio. And also I like the toggl app
ways more than the Bexio App (but naturally Toggl is just doing one thing).

## User registration

The app runs under https://toggl-bexio-sync.fly.io (Frankfurt Server). You can generate your own user as long as you have a Bexio Account.

To be able to work the same as I do you also need the following:

* A toggl track account and it's API key (can be found under https://track.toggl.com/profile).
* The ability to have projects in Bexio .
* If you want to use Webhooks (like I do), you need to generate a Webhook Token (or take the one generated at the beginning) and then 
  go to https://track.toggl.com/2131925/integrations/webhooks and create a new Webhook. 
  
  * Events: All under Time Entry (everything else is ignored)
  * URL-Endpoint: toggl-bexio-sync.fly.io/toggl-webhook
  * Secret: The Webhook Token

## Development

Environment Variables:

You need to set BEXIO_TOGGL_CLIENT_ID and BEXIO_TOGGL_CLIENT_SECRET (generate your own app to test it)

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
