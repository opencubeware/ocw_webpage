defmodule OcwWebpageWeb.TournamentLive do
  use Phoenix.LiveView
  alias OcwWebpage.Services
  alias OcwWebpage.DataAccess

  def render(assigns) do
    ~L"""
    <div class="tournament-show-page">
      <div class="row header">
        OCW &lt; back to website
      </div>
      <div class="row body">
        <div class="col s9 board">
          <%= OcwWebpageWeb.PageView.render("main_board_top.html", assigns) %>
          <%= OcwWebpageWeb.PageView.render("main_board_records.html", assigns.records) %>
          <%= OcwWebpageWeb.PageView.render("main_board_table.html", assigns.round) %>
        </div>
        <div class="col s3 sidebar">
          %{tournamentName && (
            <MainSidebarCard name=%{tournamentName} />
          )}
          %{eventsNamesWithRoundNames && (
            <MainSidebarList tournamentName=%{tournamentName} data=%{eventsNamesWithRoundNames}/>
          )}
        </div>
      </div>
      <a class="waves-effect waves-light btn" phx-click="random">Random number</a>
    </div>
    """
  end

  def mount(
        %{
          path_params: %{
            "tournament_name" => tournament_name,
            "event_name" => event_name,
            "round_name" => round_name
          }
        },
        socket
      ) do
    DataAccess.Round.subscribe()

    new_socket =
      socket
      |> assign(:tournament_name, tournament_name)
      |> assign(:event_name, event_name)
      |> assign(:round_name, round_name)

    {:ok, fetch_all(new_socket)}
  end

  def handle_info({DataAccess.Round, [:round | _], _}, socket) do
    {:noreply, fetch_all(socket)}
  end

  def handle_event("random", _params, socket) do
    DataAccess.Round.update_testing()
    {:noreply, socket}
  end

  defp fetch_all(
         %{
           assigns: %{
             tournament_name: tournament_name,
             round_name: round_name,
             event_name: event_name
           }
         } = socket
       ) do
    socket
    |> assign(:round, Services.Tournaments.fetch_round(tournament_name, event_name, round_name))
    |> assign(:records, DataAccess.Stubs.records())
    |> assign(:event_with_rounds, Services.Tournaments.fetch_event_with_rounds(tournament_name))
  end
end
