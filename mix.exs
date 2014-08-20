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
        {:socket, ">= 0.2.7", github: "meh/elixir-socket"},
        {:bencode, ">= 0.0.1", github: "mattdeboard/elixir-bencode"}
    ]
  end
end
