defmodule BeamMCP.ServerTest do
  use BeamMCP.MCPCase, async: true

  describe "server metadata and capabilities" do
    setup [:setup_server_info, :setup_server_capabilities]

    test "exposes server name and version through server_info", %{server_info: info} do
      assert_server_info(info, "BeamMCP Server", BeamMCP.version())
    end

    test "advertises resource capability in server capabilities", %{server_capabilities: capabilities} do
      assert_has_capability(capabilities, :resources)
      assert capabilities["resources"] == %{}
    end
  end

  describe "resource reading - handle_resource_read/2" do
    setup [:setup_frame]

    test "reads system information resource with all required fields", %{frame: frame} do
      result = Server.handle_resource_read("system://info", frame)
      
      assert_mcp_response(result)
      info = assert_resource_response(result)
      
      assert Map.has_key?(info, "$schema")
      assert Map.has_key?(info, "beam_mcp_version")
      assert Map.has_key?(info, "erlang_version")
      assert Map.has_key?(info, "elixir_version")
      assert Map.has_key?(info, "schedulers")
      assert Map.has_key?(info, "process_count")
      assert Map.has_key?(info, "uptime_ms")
      assert Map.has_key?(info, "memory")
      assert Map.has_key?(info, "_type_hints")
      
      assert Map.has_key?(info["memory"], "total_bytes")
      assert Map.has_key?(info["memory"], "processes_bytes")
      assert Map.has_key?(info["memory"], "atom_bytes")
      assert Map.has_key?(info["memory"], "binary_bytes")
      assert Map.has_key?(info["memory"], "ets_bytes")
      assert info["memory"]["units"] == "bytes"
      
      assert info["beam_mcp_version"] == BeamMCP.version()
      assert is_binary(info["erlang_version"])
      assert is_binary(info["elixir_version"])
      assert is_integer(info["schedulers"])
      assert is_integer(info["process_count"])
      assert is_integer(info["uptime_ms"])
    end

    test "preserves frame identity through resource read operation", %{frame: frame} do
      {:reply, _response, returned_frame} = Server.handle_resource_read("system://info", frame)
      assert returned_frame == frame
    end
  end

  describe "error handling for invalid resources" do
    setup [:setup_frame]

    test "returns server error (-32001) for non-existent resource URIs", %{frame: frame} do
      result = Server.handle_resource_read("unknown://resource", frame)
      
      error = assert_mcp_error(result, -32001)
      assert error.message == "Resource not found"
    end
  end

  describe "resource discovery - handle_resource_list/1" do
    setup [:setup_frame]

    test "lists all available resources with complete metadata", %{frame: frame} do
      {:reply, response, _frame} = Server.handle_resource_list(frame)
      
      assert Map.has_key?(response, :resources)
      assert is_list(response.resources)
      assert length(response.resources) == 1
      
      [resource] = response.resources
      assert resource.uri == "system://info"
      assert resource.name == "System Information"
      assert resource.description == "BEAM VM and runtime information including versions, memory usage, and process statistics"
      assert resource.mimeType == "application/json"
      assert Map.has_key?(resource, :schema)
      assert resource.schema.type == "object"
      assert Map.has_key?(resource.schema, :properties)
    end
  end
end