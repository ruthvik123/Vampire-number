defmodule Vampire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # list=system.argv()
    # IO.inspect list

    children = [
      # Starts a worker by calling: Proj1.Worker.start_link(arg)
      worker(Vampire.Application.Server, [%{}])
    ]


    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Proj1.Supervisor]
    {:ok,_pid} = Supervisor.start_link(children, opts)
  end

  # def testFunc(name) do
  #   IO.puts("wassup #{name}")
  # end


end
