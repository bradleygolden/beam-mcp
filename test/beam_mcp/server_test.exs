defmodule BeamMCP.ServerTest do
  use BeamMCP.MCPCase, async: true

  describe "server configuration" do
    setup [:setup_server_info, :setup_server_capabilities]

    test "has correct name and version", %{server_info: info} do
      assert_server_info(info, "BeamMCP Server", BeamMCP.version())
    end

    test "declares resource capability", %{server_capabilities: capabilities} do
      assert_has_capability(capabilities, :resources)
      assert capabilities["resources"] == %{}
    end
  end

  describe "handle_resource_read/2" do
    setup [:setup_frame]

    test "returns system info for system://info URI", %{frame: frame} do
      result = Server.handle_resource_read("system://info", frame)
      
      assert_mcp_response(result)
      info = assert_resource_response(result)
      
      assert Map.has_key?(info, "beam_mcp_version")
      assert Map.has_key?(info, "erlang_version")
      assert Map.has_key?(info, "elixir_version")
      assert Map.has_key?(info, "schedulers")
      assert Map.has_key?(info, "process_count")
      assert Map.has_key?(info, "uptime_ms")
      assert Map.has_key?(info, "memory")
      
      assert Map.has_key?(info["memory"], "total")
      assert Map.has_key?(info["memory"], "processes")
      assert Map.has_key?(info["memory"], "atom")
      assert Map.has_key?(info["memory"], "binary")
      assert Map.has_key?(info["memory"], "ets")
      
      assert info["beam_mcp_version"] == BeamMCP.version()
      assert is_binary(info["erlang_version"])
      assert is_binary(info["elixir_version"])
      assert is_integer(info["schedulers"])
      assert is_integer(info["process_count"])
      assert is_integer(info["uptime_ms"])
    end

    test "returns same frame without modifications", %{frame: frame} do
      {:reply, _response, returned_frame} = Server.handle_resource_read("system://info", frame)
      assert returned_frame == frame
    end
  end

  describe "error handling" do
    setup [:setup_frame]

    test "handle_resource_read with unknown URI returns appropriate error", %{frame: frame} do
      result = Server.handle_resource_read("unknown://resource", frame)
      
      error = assert_mcp_error(result, -32602)
      assert error.message == "Unknown resource URI"
    end
  end

  describe "resource listing" do
    setup [:setup_frame]

    test "server responds to resource list requests", %{frame: frame} do
      response = Server.handle_resource_read("system://info", frame)
      assert_mcp_response(response)
    end
  end
end