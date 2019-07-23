defmodule OcwWebpageWeb.TournamentLive do
  use Phoenix.LiveView
  import Phoenix.Controller, only: [json: 2]
  alias OcwWebpage.Services

  def render(assigns) do
    ~L"""
    <div class="tournament-show-page">
      <div class="row header">
        OCW &lt; back to website
      </div>
      <div class="row">
        <div class="col s9 board">
          {currentRound && (
            <MainBoardTop data={currentRound} />
          )}
          <MainBoardRecords data={MainBoardRecordStub} />
          {results && (
            <MainBoardTable data={results} />
          )}
        </div>
        <div class="col s3 sidebar">
          {tournamentName && (
            <MainSidebarCard name={tournamentName} />
          )}
          {eventsNamesWithRoundNames && (
            <MainSidebarList tournamentName={tournamentName} data={eventsNamesWithRoundNames}/>
          )}
        </div>
      </div>
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
    round = Services.Tournaments.fetch_round(tournament_name, event_name, round_name)

    {:ok, assign(socket, :round, round)}
  end
end
