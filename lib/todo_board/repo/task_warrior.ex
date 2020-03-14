defmodule TodoBoard.Repo.TaskWarrior do
  @moduledoc """
  Enables read/write interaction with the Taskwarrior utility
  """

  @behaviour TodoBoard.Repo

  alias TodoBoard.Todo

  @impl true
  def read_all do
    {json_output, _exit_code = 0} = System.cmd("task", ["export"])

    {:ok,
     json_output
     |> Taskwarrior.from_json(
       udas: [:rating_true, :rating_deviation, :rating_volatility]
     )
     |> Enum.map(&Todo.build/1)}
  end

  @impl true
  def write_all(_list) do
    :ok
  end
end
