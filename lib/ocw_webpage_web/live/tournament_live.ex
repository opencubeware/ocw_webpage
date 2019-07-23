defmodule OcwWebpageWeb.TournamentLive do
  use Phoenix.LiveView
  alias OcwWebpage.Services

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
          %{results && (
            <MainBoardTable data=%{results} />
          )}
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
    records = stub_records()
    event_with_rounds = Services.Tournaments.fetch_event_with_rounds(tournament_name)

    new_socket =
      socket
      |> assign(:round, round)
      |> assign(:records, records)
      |> assign(:event_with_rounds, event_with_rounds)

    {:ok, new_socket}
  end

  defp stub_records() do
    %{
      wr: %{
        single: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        },
        average: %{
          person: "Rafał Studnicki",
          time: "00:04.70"
        }
      },
      cr: %{
        single: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        },
        average: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        }
      },
      nr: %{
        single: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        },
        average: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        }
      },
      cb: %{
        single: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        },
        average: %{
          person: "Rafał Studnicki",
          time: "00:05.70"
        }
      }
    }
  end
end
