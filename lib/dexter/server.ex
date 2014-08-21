defmodule Dexter.Server do
  use Reagent.Behaviour
  use GenServer

  def handle(conn) do
    case conn |> Socket.Stream.recv! do
      nil ->
        :closed

      data ->
        conn |> Socket.Stream.send! data
        handle(conn)
    end
  end

  def say_hello do
    GenServer.call Dexter.Server, :hello
  end

  def handle_call(:hello, _, _) do
    {:ok, "Hello!"}
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
end
