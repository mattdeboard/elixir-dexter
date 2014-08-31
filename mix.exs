defmodule Dexter.Mixfile do
  use Mix.Project

  def project do
    [app: :dexter,
     version: "0.0.1",
     elixir: "~> 0.15.2-dev",
     deps: deps]
  end

  def application do
    [applications: [:logger],
    ]
  end

  defp deps do
    [
        {:socket, ">= 0.2.5", github: "meh/elixir-socket"},
        {:bencode, ">= 0.0.1", github: "tyrannosaurus/elixir-bencode"}
    ]
  end
end
