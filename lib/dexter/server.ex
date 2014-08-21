defmodule Dexter.Server do
  use Reagent.Behaviour

  def start(connection) do
    :gen_server.start __MODULE__, connection, [name: :dexter]
  end

  alias Dexter.Server

  use GenServer

  def init(conn) do
    Process.flag :trap_exit, true

    {:ok, conn}
  end

  def handle_info({ Reagent, :ack }, connection) do
    connection |> Socket.active!

    { :noreply, connection }
  end

  def handle_info({ :tcp, _, data }, connection) do
    connection |> Socket.Stream.send! data

    { :noreply, connection }
  end

  def handle_info({ :tcp_closed, _ }, _connection) do
    { :stop, :normal, _connection }
  end

  def handle_info({ :EXIT, _pid, reason }, connection) do
    connection |> Socket.active! :once

    if reason != :normal do
      :error_logger.error_report reason
    end

    { :noreply, connection }
  end

end
