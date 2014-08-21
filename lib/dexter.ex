defmodule Dexter do
  use Application

  @port 7400

  def start(_, port \\ @port) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Reagent, [Dexter.Server, [port: port]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: :dexter_sup]
    Supervisor.start_link(children, opts)
  end

end
