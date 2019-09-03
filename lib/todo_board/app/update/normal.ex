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
      List.update_at(
        model.todo_panels,
        model.todo_panel_hover_index,
        &%{&1 | selected: true}
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
    new_hover_index = hover_index_shift_up(model.todo_panel_hover_index)
    todo_panels = panel_set_hover(model.todo_panels, new_hover_index)

    %{model | todo_panels: todo_panels, todo_panel_hover_index: new_hover_index}
  end

  defp panel_navigate(model = %Model{}, :down) do
    new_hover_index = hover_index_shift_down(model.todo_panel_hover_index, model.todo_panels)
    todo_panels = panel_set_hover(model.todo_panels, new_hover_index)

    %{model | todo_panels: todo_panels, todo_panel_hover_index: new_hover_index}
  end

  defp hover_index_shift_up(_hover_index = 0), do: 0
  defp hover_index_shift_up(hover_index), do: hover_index - 1

  defp hover_index_shift_down(hover_index, todo_panels) do
    index_bottom_boundary = length(todo_panels) - 1

    case hover_index == index_bottom_boundary do
      true -> hover_index
      false -> hover_index + 1
    end
  end

  defp panel_set_hover(todo_panels, hover_index) do
    todo_panels
    |> Enum.map(&%{&1 | hover: false})
    |> List.update_at(hover_index, &%{&1 | hover: true})
  end
end
