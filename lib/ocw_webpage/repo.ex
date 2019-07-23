defmodule OcwWebpage.Repo do
  use Ecto.Repo,
    otp_app: :ocw_webpage,
    adapter: Ecto.Adapters.Postgres
end
