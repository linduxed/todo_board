defmodule TodoBoard.App.Update.Normal do
  @moduledoc """
  Update actions for when no panel is selected.
  """

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.{Model, TodoPanel}

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  @enter key(:enter)

  def update(model = %Model{}, msg) do
    case msg do
      {:event, %{key: @enter}} -> select_panel(model)
      {:event, %{ch: ?p}} -> add_panel(model)
      {:event, %{ch: ?x}} -> remove_panel(model)
      {:event, %{key: @arrow_up}} -> panel_navigate(model, :up)
      {:event, %{key: @arrow_down}} -> panel_navigate(model, :down)
      _msg -> model
    end
  end

  defp select_panel(model = %Model{}) do
    panels_with_hovered_panel_selected =
      find_and_update(
        model.todo_panels,
        _find_fun = &match?(%{hover: true}, &1),
        _update_fun = &%{&1 | selected: true}
      )

    %{model | mode: :panel_selected, todo_panels: panels_with_hovered_panel_selected}
  end

  defp add_panel(model = %Model{}) do
    new_todo_panel = TodoPanel.create_from_todos(model.todos, _hover = true)

    current_todo_panels =
      Enum.map(model.todo_panels, fn todo_panel ->
        %{todo_panel | hover: false}
      end)

    %{model | todo_panels: [new_todo_panel | current_todo_panels]}
  end

  defp remove_panel(model = %Model{}) do
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

  defp panel_navigate(model = %Model{}, :up) do
    todo_panels = panel_hover_shift_backward(model.todo_panels)

    %{model | todo_panels: todo_panels}
  end

  defp panel_navigate(model = %Model{}, :down) do
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

  defp find_and_update(list, match_fun, update_fun) do
    position_to_update = Enum.find_index(list, match_fun)
    List.update_at(list, position_to_update, update_fun)
  end
end
