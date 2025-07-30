defmodule BeamMCP.Server do
  @moduledoc """
  MCP server implementation for BeamMCP.
  
  Provides system information about the BEAM VM and runtime environment
  through the MCP resources protocol.
  """
  
  @version Mix.Project.config()[:version]
  
  use Hermes.Server,
    name: "BeamMCP Server",
    version: @version,
    capabilities: [:resources]

  @impl true
  def handle_resource_read("system://info", frame) do
    info = %{
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "beam_mcp_version" => @version,
      "erlang_version" => :erlang.system_info(:otp_release) |> to_string(),
      "elixir_version" => System.version(),
      "schedulers" => :erlang.system_info(:schedulers),
      "process_count" => :erlang.system_info(:process_count),
      "uptime_ms" => :erlang.statistics(:wall_clock) |> elem(0),
      "memory" => %{
        "total_bytes" => :erlang.memory(:total),
        "processes_bytes" => :erlang.memory(:processes),
        "atom_bytes" => :erlang.memory(:atom),
        "binary_bytes" => :erlang.memory(:binary),
        "ets_bytes" => :erlang.memory(:ets),
        "units" => "bytes"
      },
      "_type_hints" => %{
        "beam_mcp_version" => "string",
        "erlang_version" => "string",
        "elixir_version" => "string",
        "schedulers" => "integer",
        "process_count" => "integer",
        "uptime_ms" => "integer",
        "memory" => %{
          "total_bytes" => "integer",
          "processes_bytes" => "integer",
          "atom_bytes" => "integer",
          "binary_bytes" => "integer",
          "ets_bytes" => "integer",
          "units" => "string"
        }
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
        description: "BEAM VM and runtime information including versions, memory usage, and process statistics",
        mimeType: "application/json",
        schema: %{
          type: "object",
          properties: %{
            "$schema" => %{type: "string"},
            beam_mcp_version: %{type: "string", description: "BeamMCP server version"},
            erlang_version: %{type: "string", description: "Erlang/OTP version"},
            elixir_version: %{type: "string", description: "Elixir version"},
            schedulers: %{type: "integer", description: "Number of scheduler threads"},
            process_count: %{type: "integer", description: "Current number of processes"},
            uptime_ms: %{type: "integer", description: "System uptime in milliseconds"},
            memory: %{
              type: "object",
              description: "Memory usage statistics",
              properties: %{
                total_bytes: %{type: "integer", description: "Total allocated memory"},
                processes_bytes: %{type: "integer", description: "Memory used by processes"},
                atom_bytes: %{type: "integer", description: "Memory used by atoms"},
                binary_bytes: %{type: "integer", description: "Memory used by binaries"},
                ets_bytes: %{type: "integer", description: "Memory used by ETS tables"},
                units: %{type: "string", enum: ["bytes"], description: "Memory measurement unit"}
              }
            },
            _type_hints: %{type: "object", description: "Type information for each field"}
          }
        }
      }
    ]
    
    {:reply, %{resources: resources}, frame}
  end
end