defmodule BeamMCP.MCPCase.Assertions do
  @moduledoc """
  MCP-specific assertions for testing BeamMCP server.
  """
  
  import ExUnit.Assertions
  alias Hermes.Server.Frame
  
  @doc """
  Asserts that a response is a valid MCP response with the expected structure.
  """
  def assert_mcp_response({:reply, response, frame}) do
    assert is_map(response)
    assert %Frame{} = frame
    response
  end
  
  @doc """
  Asserts that an error response has the expected code and message pattern.
  """
  def assert_mcp_error({:error, error, frame}, expected_code) do
    assert is_map(error)
    assert error.code == expected_code
    assert is_binary(error.message)
    assert %Frame{} = frame
    error
  end
  
  @doc """
  Asserts that a resource response contains valid JSON content.
  """
  def assert_resource_response({:reply, response, _frame}) do
    assert response.mimeType == "application/json"
    assert is_binary(response.content)
    
    # Verify the content is valid JSON
    assert {:ok, decoded} = Jason.decode(response.content)
    decoded
  end
  
  @doc """
  Asserts that server info matches expected values.
  """
  def assert_server_info(info, expected_name, expected_version) do
    assert info["name"] == expected_name
    assert info["version"] == expected_version
    info
  end
  
  @doc """
  Asserts that capabilities contain expected values.
  """
  def assert_has_capability(capabilities, capability) do
    assert Map.has_key?(capabilities, to_string(capability))
    capabilities[to_string(capability)]
  end
end