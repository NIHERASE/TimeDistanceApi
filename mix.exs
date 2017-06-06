defmodule TimeDistanceApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :time_distance_api,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: [
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :cowboy, :plug],
      mod: {TimeDistanceApi, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.1"},
      {:poison, "~> 3.1"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:exvcr, "~> 0.8", only: :test}
    ]
  end
end
