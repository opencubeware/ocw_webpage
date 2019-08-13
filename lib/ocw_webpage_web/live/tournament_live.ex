defmodule OcwWebpageWeb.TournamentLive do
  use Phoenix.LiveView
  require Ecto.Query
  alias OcwWebpage.{DataAccess, Services}

  def render(assigns) do
    ~L"""
    <%= unless Map.has_key?(assigns, :error) do %>
      <div class="tournament-show-page">
        <div class="row header">
          <div class="col s12">OCW &lt; back to website</div>
        </div>
        <div class="row body">
          <div class="col s9 board">
            <%= OcwWebpageWeb.PageView.render("main_board_top.html", assigns) %>
            <%= OcwWebpageWeb.PageView.render("main_board_records.html", assigns.records) %>
            <%= OcwWebpageWeb.PageView.render("main_board_table.html", assigns) %>
          </div>
          <div class="col s3 sidebar">
            <%= OcwWebpageWeb.PageView.render("main_sidebar_card.html", assigns.round) %>
            <%= OcwWebpageWeb.PageView.render("main_sidebar_list.html", assigns) %>
          </div>
        </div>
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

  def handle_info({DataAccess.Round, [:round | _], result}, socket) do
    IO.inspect(result)
    IO.inspect(socket)
    IO.inspect(round_ids_match?(result, socket))

    new_socket =
      case round_ids_match?(result, socket) do
        true ->
          db_result = OcwWebpage.Repo.preload(result, :round)
          db_result_round_id = db_result.round.id

          index =
            Ecto.Query.from(r in DataAccess.Schemas.Result,
              where: r.round_id == ^db_result_round_id,
              preload: :round
            )
            |> OcwWebpage.Repo.all()
            |> Enum.sort_by(fn map -> {map.average, Enum.min(map.attempts)} end)
            |> Enum.find_index(fn x -> x == db_result end)

          socket |> fetch_all() |> assign(:index, index)

        false ->
          socket |> fetch_all()
      end

    {:noreply, new_socket}
  end

  def handle_params(params, _url, socket) do
    new_socket =
      socket
      |> assign(:tournament_name, URI.decode(params["tournament_name"]))
      |> assign(:event_name, URI.decode(params["event_name"]))
      |> assign(:round_name, URI.decode(params["round_name"]))

    {:noreply, fetch_all(new_socket)}
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
    else
      {:error, status} ->
        assign(socket, :error, status)
    end
  end

  def round_ids_match?(%{round_id: result_round_id}, %{assigns: %{round: %{id: round_id}}}) do
    result_round_id == round_id
  end
end
