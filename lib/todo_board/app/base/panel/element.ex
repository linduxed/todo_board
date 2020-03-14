defmodule TodoBoard.App.Base.TodoPanel.Element do
  @moduledoc """
  Lines in a `TodoBoard.TodoPanel`
  """

  @enforce_keys [:todo]
  defstruct [:todo, :hover, :selected]
end
