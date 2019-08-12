defmodule OcwWebpageWeb.AdminTournamentLive do
  use Phoenix.LiveView
  alias OcwWebpage.{DataAccess, Services}

  def render(assigns) do
    ~L"""
    <%= unless Map.has_key?(assigns, :error) do %>
      <div class="admin-round-page">
        <div class="row header">
          <div class="col s6">
            <%= OcwWebpageWeb.PageView.render("main_board_top.html", assigns) %>
          </div>
          <div class="col s6 search-box">
            <div class="col s12 search-box__title">
              Search
            </div>
            <div class="col s6 search-box__input">
              <form phx-change="update-board">
                <input type="text" name="q" value="<%= @query %>" class="input" placeholder="Search..."/>
              </form>
            </div>
          </div>
        </div>
        <div class="row body">
          <div class="col s3 form">
            <%= OcwWebpageWeb.PageView.render("admin_result_box_form.html", assigns) %>
          </div>
          <div class="col s9 table">
            <%= OcwWebpageWeb.PageView.render("admin_board_table.html", assigns) %>
          </div>
        </div>
        <a class="waves-effect waves-light btn" phx-click="random">Random number</a>
      </div>
    <% else %>
      <%= assigns.error %>
    <% end %>
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

  def handle_params(params, _url, socket) do
    new_socket =
      socket
      |> assign(:tournament_name, URI.decode(params["tournament_name"]))
      |> assign(:event_name, URI.decode(params["event_name"]))
      |> assign(:round_name, URI.decode(params["round_name"]))

    {:noreply, fetch_all(new_socket)}
  end

  def handle_event(
        "update-board",
        %{"q" => query},
        %{
          assigns: %{
            tournament_name: tournament_name,
            round_name: round_name,
            event_name: event_name
          }
        } = socket
      ) do
    results =
      Services.Tournaments.fetch_filtered_results(
        tournament_name,
        event_name,
        round_name,
        query
      )

    new_socket = assign(socket, :query, query)

    {:noreply, assign(new_socket, :results, results)}
  end

  def handle_event("edit-result", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("change-player", index, socket) do
    with {:ok, result} <- Services.Tournaments.fetch_result(index) do
      {:noreply, assign(socket, :current_result, result)}
    end
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
    with {:ok, round} <-
           Services.Tournaments.fetch_round(tournament_name, event_name, round_name),
         {:ok, event_with_rounds} <- Services.Tournaments.fetch_event_with_rounds(tournament_name) do
      socket
      |> assign(:round, round)
      |> assign(:records, DataAccess.Stubs.records())
      |> assign(:event_with_rounds, event_with_rounds)
      |> assign(:results, round.results)
      |> assign(:current_result, Enum.fetch!(round.results, 0))
      |> assign(:query, "")
    else
      {:error, status} ->
        assign(socket, :error, status)
    end
  end
end
