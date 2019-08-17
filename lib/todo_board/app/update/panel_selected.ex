defmodule TodoBoard.App.Update.PanelSelected do
  @moduledoc """
  Update actions for the cases where a panel has been selected.
  """

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.Model
  alias TodoBoard.TodoPanel

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  @escape key(:esc)

  def update(model = %Model{}, msg) do
    case msg do
      {:event, %{key: @escape}} -> return_to_normal_mode(model)
      {:event, %{key: @arrow_up}} -> todo_navigate(model, :up)
      {:event, %{key: @arrow_down}} -> todo_navigate(model, :down)
      _msg -> model
    end
  end

  defp return_to_normal_mode(model = %Model{}) do
    panels_no_selected = Enum.map(model.todo_panels, &%{&1 | selected: false})

    %{model | mode: :normal, todo_panels: panels_no_selected}
  end

  defp todo_navigate(model = %Model{}, direction) do
    shift_fun =
      case direction do
        :up -> &shift_hover_backward/1
        :down -> &shift_hover_forward/1
      end

    todo_panels =
      find_and_update(
        model.todo_panels,
        _find_fun = &match?(%{selected: true}, &1),
        _update_fun = &%{&1 | elements: shift_fun.(&1.elements)}
      )

    %{model | todo_panels: todo_panels}
  end

  defp shift_hover_forward(elements) do
    shift_hover(elements)
  end

  defp shift_hover_backward(elements) do
    elements
    |> Enum.reverse()
    |> shift_hover()
    |> Enum.reverse()
  end

  defp shift_hover(elements) do
    shift_hover(elements, false)
  end

  defp shift_hover(_elements = [], _last_was_hover), do: []

  defp shift_hover(elements = [%TodoPanel.Element{hover: true}], _last_was_hover = false) do
    elements
  end

  defp shift_hover([head = %TodoPanel.Element{hover: false} | tail], _last_was_hover = false) do
    [head | shift_hover(tail, false)]
  end

  defp shift_hover([head = %TodoPanel.Element{hover: true} | tail], _last_was_hover = false) do
    [%{head | hover: false} | shift_hover(tail, _last_was_hover = true)]
  end

  defp shift_hover([head = %TodoPanel.Element{hover: false} | tail], _last_was_hover = true) do
    [%{head | hover: true} | shift_hover(tail, _last_was_hover = false)]
  end

  defp find_and_update(list, match_fun, update_fun) do
    position_to_update = Enum.find_index(list, match_fun)
    List.update_at(list, position_to_update, update_fun)
  end
end
