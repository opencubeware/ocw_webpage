defmodule OcwWebpageWeb.Router do
  use OcwWebpageWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", OcwWebpageWeb do
    pipe_through(:api)

    scope "/v1" do
      get(
        "/tournaments/:tournament_name/events/:event_name/rounds/:round_name",
        Api.V1.Rounds,
        :show
      )

      get(
        "/tournaments/:tournament_name/events_with_rounds",
        Api.V1.Tournaments,
        :show_events_with_tournaments
      )
    end
  end

  scope "/", OcwWebpageWeb do
    pipe_through(:browser)
    live("/counter", CounterLive)
    get("/*path", PageController, :index)
  end
end
