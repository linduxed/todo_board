defmodule TodoBoard.TodoPanel do
  defstruct elements: [],
            element_hover_index: 0,
            hover: false,
            selected: false

  def create_from_todos(todos, hover) do
    elements =
      todos
      |> Enum.map(&%__MODULE__.Element{todo: &1})
      |> List.update_at(0, &%{&1 | hover: true})

    %__MODULE__{
      elements: elements,
      element_hover_index: 0,
      hover: hover,
      selected: false
    }
  end
end
