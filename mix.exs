defmodule BeamMCP.MixProject do
  use Mix.Project

  def project do
    [
      app: :beam_mcp,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BeamMCP.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
