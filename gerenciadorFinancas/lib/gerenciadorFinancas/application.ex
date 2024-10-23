defmodule GerenciadorFinancas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GerenciadorFinancasWeb.Telemetry,
      GerenciadorFinancas.Repo,
      {DNSCluster, query: Application.get_env(:gerenciadorFinancas, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GerenciadorFinancas.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GerenciadorFinancas.Finch},
      # Start a worker by calling: GerenciadorFinancas.Worker.start_link(arg)
      # {GerenciadorFinancas.Worker, arg},
      # Start to serve requests, typically the last entry
      GerenciadorFinancasWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GerenciadorFinancas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GerenciadorFinancasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
