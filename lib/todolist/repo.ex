defmodule TodoList.Repo do
  use Ecto.Repo,
    otp_app: :TodoList,
    adapter: Ecto.Adapters.Postgres
end
