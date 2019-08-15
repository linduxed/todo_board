defmodule TodoBoard do
  @moduledoc """
  Defines the supervision tree for the application.
  """

  @version Mix.Project.config()[:version]
  def version, do: @version

  use Application

  @doc """
  Gets called to set up the supervision tree for the application.

  Worth noting is that the Ratatouille runtime is supplied with a custom
  `quit_events` list, as the default includes the letters `q` and `Q` as always
  present application exit keys.
  """
  def start(_type, _args) do
    runtime_opts = [
      app: TodoBoard.App,
      shutdown: {:application, :todo_board},
      quit_events: [key: Ratatouille.Constants.key(:ctrl_c)]
    ]

    children = [
      {Ratatouille.Runtime.Supervisor, runtime: runtime_opts}
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: TodoBoard.Supervisor
    )
  end

  @doc """
  Do a hard shutdown after the application has been stopped.

  Another, perhaps better, option is `System.stop/0`, but this results in a
  rather annoying lag when quitting the terminal application.
  """
  def stop(_state) do
    System.halt()
  end
end
