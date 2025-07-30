defmodule BeamMCP.Server do
  @version Mix.Project.config()[:version]
  
  use Hermes.Server,
    name: "BeamMCP Server",
    version: @version,
    capabilities: [:resources]

  @impl true
  def handle_resource_read("system://info", frame) do
    info = %{
      beam_mcp_version: @version,
      erlang_version: :erlang.system_info(:otp_release) |> to_string(),
      elixir_version: System.version(),
      schedulers: :erlang.system_info(:schedulers),
      process_count: :erlang.system_info(:process_count),
      uptime_ms: :erlang.statistics(:wall_clock) |> elem(0),
      memory: %{
        total: :erlang.memory(:total),
        processes: :erlang.memory(:processes),
        atom: :erlang.memory(:atom),
        binary: :erlang.memory(:binary),
        ets: :erlang.memory(:ets)
      }
    }

    {:reply, %{content: Jason.encode!(info, pretty: true), mimeType: "application/json"}, frame}
  end

  def handle_resource_read(_uri, frame) do
    {:error, %{code: -32602, message: "Unknown resource URI"}, frame}
  end
end