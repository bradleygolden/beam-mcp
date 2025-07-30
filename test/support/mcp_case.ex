defmodule BeamMCP.MCPCase do
  @moduledoc """
  Test case template for BeamMCP server testing.
  
  Provides utilities for testing MCP protocol interactions including:
  - Mock transport for testing without real I/O
  - Message builders for consistent test data
  - Assertion helpers for MCP-specific validations
  - Setup functions for common test scenarios
  """
  
  use ExUnit.CaseTemplate
  
  using opts do
    quote do
      use ExUnit.Case, unquote(opts)
      
      import BeamMCP.MCPCase.Assertions
      import BeamMCP.MCPCase.Builders
      import BeamMCP.MCPCase.Setup
      
      alias Hermes.Server.Frame
      alias BeamMCP.Server
    end
  end
end