defmodule Dexter.Server do
  use GenServer
  require Code
  require Socket

  def start_link(args) do
    GenServer.start_link __MODULE__, args, name: __MODULE__
  end

  def init({:port, port}) do
    Process.flag :trap_exit, true
    socket = Socket.TCP.listen! port
    Socket.TCP.accept socket, timeout: 5000
    IO.puts "Accepting connections on port #{port}"
    {:ok, socket}
  end

  def handle_cast({:eval_string, string}, state) do
    {:reply, eval_string(string), state}
  end

  def handle_cast({:eval_quoted, string}, state) do
    {:reply, eval_quoted(string), state}
  end

  def eval_string(string, bindings \\ [], opts \\ []) do
    Code.eval_string string, bindings, opts
  end

  def eval_quoted(quoted, bindings \\ [], opts \\ []) do
    Code.eval_quoted quoted, bindings, opts
  end
end
