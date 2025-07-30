defmodule BeamMCP.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Hermes.Server.Transport.STDIO, [
        server: BeamMCP.Server
      ]}
    ]

    opts = [strategy: :one_for_one, name: BeamMCP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
