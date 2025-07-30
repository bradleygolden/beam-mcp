defmodule BeamMCP.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the MCP server with STDIO transport
      {Hermes.Server, [
        server: BeamMCP.Server,
        transport: :stdio
      ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BeamMCP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
