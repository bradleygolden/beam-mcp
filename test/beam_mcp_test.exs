defmodule BeamMCPTest do
  use ExUnit.Case
  doctest BeamMCP

  test "version returns correct version string" do
    assert BeamMCP.version() == "0.1.0"
  end
end
