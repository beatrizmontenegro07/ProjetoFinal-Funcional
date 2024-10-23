defmodule GerenciadorFinancas.Repo do
  use Ecto.Repo,
    otp_app: :gerenciadorFinancas,
    adapter: Ecto.Adapters.Postgres
end
