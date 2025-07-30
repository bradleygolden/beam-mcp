defmodule BeamMCP.MixProject do
  use Mix.Project

  def project do
    [
      app: :beam_mcp,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BeamMCP.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:usage_rules, "~> 0.1", only: [:dev]},
      {:claude, "~> 0.2", only: [:dev], runtime: false},
      {:igniter, "~> 0.6", only: [:dev, :test]},
      {:hermes_mcp, "~> 0.13.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
