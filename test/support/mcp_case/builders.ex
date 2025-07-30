defmodule BeamMCP.MCPCase.Builders do
  @moduledoc """
  Message builders for creating test data in MCP protocol format.
  """
  
  alias Hermes.Server.Frame
  
  @doc """
  Creates a test frame with optional assigns.
  """
  def build_frame(assigns \\ %{}) do
    %Frame{assigns: assigns}
  end
  
  @doc """
  Creates a mock client info for testing.
  """
  def build_client_info(name \\ "test-client", version \\ "1.0.0") do
    %{
      "name" => name,
      "version" => version
    }
  end
  
  @doc """
  Creates a mock initialization request.
  """
  def build_init_request(opts \\ []) do
    %{
      "jsonrpc" => "2.0",
      "id" => Keyword.get(opts, :id, 1),
      "method" => "initialize",
      "params" => %{
        "protocolVersion" => Keyword.get(opts, :protocol_version, "2024-11-05"),
        "clientInfo" => Keyword.get(opts, :client_info, build_client_info()),
        "capabilities" => Keyword.get(opts, :capabilities, %{})
      }
    }
  end
  
  @doc """
  Creates a resource read request.
  """
  def build_resource_read_request(uri, opts \\ []) do
    %{
      "jsonrpc" => "2.0",
      "id" => Keyword.get(opts, :id, 1),
      "method" => "resources/read",
      "params" => %{
        "uri" => uri
      }
    }
  end
  
  @doc """
  Creates a tools list request.
  """
  def build_tools_list_request(opts \\ []) do
    %{
      "jsonrpc" => "2.0",
      "id" => Keyword.get(opts, :id, 1),
      "method" => "tools/list",
      "params" => %{}
    }
  end
  
  @doc """
  Creates a resources list request.
  """
  def build_resources_list_request(opts \\ []) do
    %{
      "jsonrpc" => "2.0",
      "id" => Keyword.get(opts, :id, 1),
      "method" => "resources/list",
      "params" => %{}
    }
  end
end