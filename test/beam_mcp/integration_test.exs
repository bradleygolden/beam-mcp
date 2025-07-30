defmodule BeamMCP.IntegrationTest do
  use BeamMCP.MCPCase
  
  @moduledoc """
  Integration tests for BeamMCP server.
  
  These tests verify the server works correctly with the MCP protocol
  using mock transports and message builders.
  """

  describe "MCP protocol integration" do
    setup [:setup_complete_environment]

    test "server responds to protocol requests", context do
      assert_server_info(context.server_info, "BeamMCP Server", BeamMCP.version())
      assert_has_capability(context.server_capabilities, :resources)
    end

    test "resource reading works with proper MCP structure", %{frame: frame} do
      result = Server.handle_resource_read("system://info", frame)
      
      assert_mcp_response(result)
      info = assert_resource_response(result)
      assert info["beam_mcp_version"] == BeamMCP.version()
    end
  end

  describe "MCP message handling" do
    setup [:setup_frame]

    test "server handles resource read requests", %{frame: frame} do
      request = build_resource_read_request("system://info")
      result = Server.handle_resource_read(request["params"]["uri"], frame)
      
      response = assert_mcp_response(result)
      assert response.mimeType == "application/json"
    end

    test "server handles unknown resource URIs", %{frame: frame} do
      request = build_resource_read_request("unknown://resource")
      result = Server.handle_resource_read(request["params"]["uri"], frame)
      
      assert_mcp_error(result, -32602)
    end
  end

  describe "server lifecycle" do
    test "server module is properly configured" do
      assert function_exported?(Server, :server_info, 0)
      assert function_exported?(Server, :server_capabilities, 0)
      assert function_exported?(Server, :handle_resource_read, 2)
    end

    test "server info is consistent" do
      info1 = Server.server_info()
      info2 = Server.server_info()
      
      assert info1 == info2
      assert_server_info(info1, "BeamMCP Server", BeamMCP.version())
    end
  end
end