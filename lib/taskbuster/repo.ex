defmodule Taskbuster.Repo do
  use Ecto.Repo,
    otp_app: :taskbuster,
    adapter: Ecto.Adapters.Postgres
end
