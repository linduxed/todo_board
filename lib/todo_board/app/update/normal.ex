defmodule TodoBoard.App.Update.Normal do
  @moduledoc """
  Update actions for when no panel is selected.
  """

  alias TodoBoard.{Model, TodoPanel}

  def select_panel(model = %Model{}) do
    panels_with_hovered_panel_selected =
      Enum.map(model.todo_panels, fn
        todo_panel = %{hover: true} -> %{todo_panel | selected: true}
        todo_panel -> todo_panel
      end)

    %{model | mode: :panel_selected, todo_panels: panels_with_hovered_panel_selected}
  end

  def add_panel(model = %Model{}) do
    panel_elements = Enum.map(model.todos, &%TodoPanel.Element{todo: &1})

    new_todo_panel = %TodoPanel{elements: panel_elements, hover: true, selected: false}

    current_todo_panels =
      Enum.map(model.todo_panels, fn todo_panel ->
        %{todo_panel | hover: false}
      end)

    %{model | todo_panels: [new_todo_panel | current_todo_panels]}
  end

  def remove_panel(model = %Model{}) do
    new_todo_panels =
      case model.todo_panels do
        [single_panel] ->
          [single_panel]

        [%TodoPanel{hover: true} | [first_remaining_panel | rest]] ->
          [%{first_remaining_panel | hover: true} | rest]

        [_dropped_panel | rest] ->
          rest
      end

    %{model | todo_panels: new_todo_panels}
  end

  def panel_navigate(model = %Model{}, :up) do
    todo_panels = panel_hover_shift_backward(model.todo_panels)

    %{model | todo_panels: todo_panels}
  end

  def panel_navigate(model = %Model{}, :down) do
    todo_panels = panel_hover_shift_forward(model.todo_panels)

    %{model | todo_panels: todo_panels}
  end

  defp panel_hover_shift_forward(todo_panels) do
    panel_hover_shift(todo_panels)
  end

  defp panel_hover_shift_backward(todo_panels) do
    todo_panels
    |> Enum.reverse()
    |> panel_hover_shift()
    |> Enum.reverse()
  end

  defp panel_hover_shift(todo_panels) do
    panel_hover_shift(todo_panels, false)
  end

  defp panel_hover_shift(_todo_panels = [], _last_was_hover), do: []

  defp panel_hover_shift(todo_panels = [%TodoPanel{hover: true}], _last_was_hover = false) do
    todo_panels
  end

  defp panel_hover_shift([head = %TodoPanel{hover: false} | tail], _last_was_hover = false) do
    [head | panel_hover_shift(tail, false)]
  end

  defp panel_hover_shift([head = %TodoPanel{hover: true} | tail], _last_was_hover = false) do
    [%{head | hover: false} | panel_hover_shift(tail, _last_was_hover = true)]
  end

  defp panel_hover_shift([head = %TodoPanel{hover: false} | tail], _last_was_hover = true) do
    [%{head | hover: true} | panel_hover_shift(tail, _last_was_hover = false)]
  end
end