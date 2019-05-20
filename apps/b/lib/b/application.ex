defmodule B.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Connect to :a
    :b
    |> Application.get_env(:nodes)
    |> Keyword.get(:a)
    |> Node.connect()

    children = [
      B.CodeChangeServer
    ]

    opts = [strategy: :one_for_one, name: B.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
