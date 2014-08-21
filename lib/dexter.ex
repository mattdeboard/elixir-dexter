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
    opts = [strategy: :one_for_one, name: Dexter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defrecord State, supervisor: nil, name: nil, plugins: [], clients: HashSet.new

  def init(options) do
    case Supervisor.start_link do
      {:ok, pid} ->
        {:ok, State[supervisor: pid]}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
