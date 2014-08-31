defmodule Dexter.Server do
  use GenServer
  require Code
  require Socket

  def start(port) do
    :gen_server.start __MODULE__, port, [name: :dexter]
  end

  def init(port) do
    Process.flag :trap_exit, true
    socket = Socket.TCP.listen! port
    {:ok, socket}
  end

  def handle_call(:eval_string, _from, string) do
    {:reply, eval_string(string)}
  end

  def eval_string(string, bindings \\ [], opts \\ []) do
    Code.eval_string string, bindings, opts
  end

  def eval_quoted(quoted, bindings \\ [], opts \\ []) do
    Code.eval_quoted quoted, bindings, opts
  end

end
