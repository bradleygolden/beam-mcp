defmodule BeamMCP do
  @moduledoc """
  BeamMCP: An Elixir implementation of an MCP (Model Context Protocol) server.
  """

  @version Mix.Project.config()[:version]

  @doc """
  Returns the current version of BeamMCP.
  
  ## Examples
  
      iex> BeamMCP.version()
      "0.1.0"
  
  """
  def version do
    @version
  end
end
