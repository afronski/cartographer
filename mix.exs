defmodule Cartographer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cartographer,
      version: "0.0.1",
      elixir: "~> 1.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:excheck, "~> 0.3", only: :test},
      {:triq, github: "krestenkrab/triq", only: :test}
    ]
  end
end
