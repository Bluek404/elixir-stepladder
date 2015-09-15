defmodule StepladderTest do
  use ExUnit.Case

  def handle(client) do
    client = Stepladder.Socket.init(client, <<"0000000000000000">>)

    data = client |> Socket.Stream.recv!
    IO.inspect data
    client |> Socket.Stream.send!("OK!")
    client |> Socket.close
  end

  def serve(server) do
      client = server |> Socket.TCP.accept!
      handle(client)
  end

  test "ase stream" do
    server = Socket.TCP.listen!(8082)

    spawn(fn -> server |> serve end)

    client = Socket.TCP.connect!("127.0.0.1", 8082)
    client = Stepladder.Socket.init(client, <<"0000000000000000">>)

    client |> Socket.Stream.send!("OK?")
    data = client |> Socket.Stream.recv!
    IO.inspect data
    client |> Socket.close
  end
end
