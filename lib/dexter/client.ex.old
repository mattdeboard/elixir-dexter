defmodule Dexter.Client do
  def start(protocol \\ "tcp", host \\ "localhost", port \\ 7400,
            secure? \\ false) do
    GenServer.start(__MODULE__,
                    [protocol: protocol, host: host, port: port,
                     secure?: secure?],
                    [name: :dexter_client])
  end

  use GenServer

  def init(args) do
    Process.flag :trap_exit, true
    uri = "#{args[:protocol]}://#{args[:host]}:#{args[:port]}"
    sock = Socket.connect! uri
    listener = %Reagent.Listener{socket: sock, secure: args[:secure?]}
    conn = %Reagent.Connection{socket: sock, id: :dexter_conn,
                               listener: listener}
    {:ok, conn}
  end

  def handle_info({ Reagent, :ack }, connection) do
    connection |> Socket.packet! :line

    :gen_server.cast :sup_dexter, { connection, :connected }

    Event.trigger(connection, :connected) |> Process.link

    { :noreply, connection }
  end

  def handle_info({ :tcp, _, line }, connection) do
    Event.parse(connection, line |> String.replace(~r/\r?\n$/, ""))
    |> Process.link

    { :noreply, connection }
  end

  def handle_info({ :tcp_closed, _ }, connection) do
    :gen_server.cast :sup_dexter, { connection, :disconnected }

    Event.trigger(connection, :disconnected)

    { :noreply, connection }
  end

  def handle_info({ :EXIT, _pid, reason }, connection) do
    connection |> Socket.active! :once

    if reason != :normal do
      :error_logger.error_report reason
    end

    { :noreply, connection }
  end

  def handle_cast(:shutdown, _connection) do
    { :stop, :normal, _connection }
  end

  def handle_cast({ :send, data }, connection) do
    Enum.each List.wrap(data), &Socket.Stream.send!(connection, [&1, "\r\n"])

    { :noreply, connection }
  end

  def handled(pid) do
    :gen_server.cast(pid, :handled)
  end
end
