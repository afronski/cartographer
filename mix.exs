defmodule Cartographer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cartographer,

      version: "0.0.1",
      elixir: "~> 1.0",

      test_coverage: [tool: Coverex.Task],

      deps: deps,
      package: package,
      description: description
    ]
  end

  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:coverex, "~> 1.4.1", only: :test},

      {:excheck, "~> 0.3", only: :test},
      {:triq, github: "krestenkrab/triq", only: :test}
    ]
  end

  defp package do
    [
      files: [ "lib", "mix.exs", "README*", "LICENSE*" ],
      maintainers: [ "Wojtek Gawroński" ],
      licenses: [ "MIT" ],
      links: %{
        "GitHub" => "https://github.com/afronski/cartographer",
        "Docs" => "https://github.com/afronski/cartographer/wiki"
      }
    ]
  end

  defp description do
    """
    Geohash related utilities implementation in Elixir.
    """
  end
end
