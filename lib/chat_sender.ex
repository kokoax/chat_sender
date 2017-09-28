defmodule ChatSender do
  @def_domain "localhost"
  @def_port   2000
  def connect(domain, port) do
    {:ok, sock} = :gen_tcp.connect('#{dimain}', @def_port, [:binary, packet: 0, active: false])
    sock
  end

  def do_process(nil) do
    IO.warn "arguments invalid"
  end

  def do_process([username, port, domain, message]) do
    sock = connect(domain, port)
    # TODO: must send username (and password)
    :ok = :gen_tcp.send(sock, message)
    {:ok, res}:gen_tcp.recv(sock, 0)
    IO.puts res
    :gen_tcp.close(sock)
  end

  def parse_args(argv) do
    {options,_,_} = argv |> OptionParser.parse(
      switches: [
        username: :string,
        port: :integer,
        domain: :string,
        message: :string
      ],
      aliases:  [
        u: :username,
        p: :port,
        d: :domain,
        m: :message
      ])
    # keyword listだと順番が保持され、面倒なのでMapでpattern match
    case options |> Enum.into(%{}) do
      %{domina: domain, port: port, username: username, message: message} ->
        [username, port, domain, message]
      %{port: port, username: username, message: message} ->
        [username, port, @def_domain, message]
      %{domain: domain, username: username, message: message} ->
        [username, @def_port, domain, message]
      %{username: username, message: message} ->
        [username, @def_port, @def_domain, message]
      _ ->
        nil
    end
  end

  def main(opts) do
    opts |> parse_args |> do_process
  end
end
