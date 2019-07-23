defmodule OcwWebpageWeb.Api.V1.Tournaments do
  use OcwWebpageWeb, :controller

  alias OcwWebpage.Services

  @spec show_events_with_tournaments(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show_events_with_tournaments(conn, %{"tournament_name" => tournament_name}) do
    conn
    |> put_status(:accepted)
    |> json(Services.Tournaments.fetch_event_with_rounds(tournament_name))
  end
end
