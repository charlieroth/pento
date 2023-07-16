defmodule Pento.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PentoWeb.Telemetry,
      Pento.Repo,
      {Phoenix.PubSub, name: Pento.PubSub},
      {Finch, name: Pento.Finch},
      PentoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Pento.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PentoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
