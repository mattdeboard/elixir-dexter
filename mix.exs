defmodule Dexter.Mixfile do
  use Mix.Project

  def project do
    [app: :dexter,
     version: "0.0.1",
     elixir: "~> 0.15.2-dev",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
        {:reagent, github: "meh/reagent"},
        {:bencode, ">= 0.0.1", github: "tyrannosaurus/elixir-bencode"}
    ]
  end
end
