defmodule TodoBoard.TodoPanel.Element do
  @enforce_keys [:todo]
  defstruct [:todo, :hover, :selected]
end
