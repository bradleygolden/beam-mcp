defmodule BeamMCP.MCPCase.Setup do
  @moduledoc """
  Setup functions for common test scenarios in BeamMCP.
  """
  
  alias BeamMCP.Server
  alias Hermes.Server.Frame
  import BeamMCP.MCPCase.Builders
  
  @doc """
  Sets up a basic test context with a frame.
  """
  def setup_frame(_context) do
    {:ok, frame: build_frame()}
  end
  
  @doc """
  Sets up a test context with an initialized frame.
  """
  def setup_initialized_frame(_context) do
    frame = %Frame{
      assigns: %{},
      initialized: true
    }
    {:ok, frame: frame}
  end
  
  @doc """
  Sets up server info for testing.
  """
  def setup_server_info(_context) do
    info = Server.server_info()
    {:ok, server_info: info}
  end
  
  @doc """
  Sets up server capabilities for testing.
  """
  def setup_server_capabilities(_context) do
    capabilities = Server.server_capabilities()
    {:ok, server_capabilities: capabilities}
  end
  
  @doc """
  Sets up a complete test environment with frame and server metadata.
  """
  def setup_complete_environment(_context) do
    frame = build_frame()
    info = Server.server_info()
    capabilities = Server.server_capabilities()
    
    {:ok, 
      frame: frame,
      server_info: info,
      server_capabilities: capabilities
    }
  end
end