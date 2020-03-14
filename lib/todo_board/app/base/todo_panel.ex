defmodule TodoBoard.App.Base.TodoPanel do
  @moduledoc """
  Main screen component, houses `TodoBoard.Todo` elements
  """

  @enforce_keys [
    :elements,
    :hover,
    :selected
  ]
  defstruct [
    :elements,
    :hover,
    :selected,
    element_hover_index: 0
  ]

  def create_from_todos(todos, hover) do
    elements =
      todos
      |> Enum.map(&%__MODULE__.Element{todo: &1, hover: false, selected: false})
      |> List.update_at(0, &%{&1 | hover: true})

    %__MODULE__{
      elements: elements,
      element_hover_index: 0,
      hover: hover,
      selected: false
    }
  end
end
