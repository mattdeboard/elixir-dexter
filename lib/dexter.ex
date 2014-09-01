defmodule Dexter do
  use Application

  @port 7400

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    port = case _args[:port] do
             nil ->
               @port
             x ->
               x
           end

    children = [
      worker(Dexter.Server, [port: port])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dexter.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
