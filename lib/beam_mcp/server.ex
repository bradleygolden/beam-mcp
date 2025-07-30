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
        total_bytes: :erlang.memory(:total),
        processes_bytes: :erlang.memory(:processes),
        atom_bytes: :erlang.memory(:atom),
        binary_bytes: :erlang.memory(:binary),
        ets_bytes: :erlang.memory(:ets),
        units: "bytes"
      }
    }

    {:reply, %{content: Jason.encode!(info, pretty: true), mimeType: "application/json"}, frame}
  end

  def handle_resource_read(_uri, frame) do
    {:error, %{code: -32001, message: "Resource not found"}, frame}
  end

  def handle_resource_list(frame) do
    resources = [
      %{
        uri: "system://info",
        name: "System Information",
        description: "BEAM VM and runtime information",
        mimeType: "application/json"
      }
    ]
    
    {:reply, %{resources: resources}, frame}
  end
end