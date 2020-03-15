defmodule TodoBoard.App.Listing.Update.Normal do
  @moduledoc """
  Update actions for when no panel is selected.
  """

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Base.{Model, TodoPanel}

  require Model

  Model.defp__update_tab_data(:listing)

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
    %{model | mode: :panel_selected}
    |> update_tab_data(fn listing_data ->
      panels_with_hovered_panel_selected =
        List.update_at(
          listing_data.todo_panels,
          listing_data.todo_panel_hover_index,
          &%{&1 | selected: true}
        )

      %{listing_data | todo_panels: panels_with_hovered_panel_selected}
    end)
  end

  defp add_panel(model = %Model{}) do
    model
    |> update_tab_data(fn listing_data ->
      new_hover_index = 0
      new_todo_panel = TodoPanel.create_from_todos(model.todos, _hover = true)

      current_todo_panels =
        Enum.map(listing_data.todo_panels, fn todo_panel ->
          %{todo_panel | hover: false}
        end)

      %{
        listing_data
        | todo_panels: [new_todo_panel | current_todo_panels],
          todo_panel_hover_index: new_hover_index
      }
    end)
  end

  defp remove_panel(model = %Model{}) do
    model
    |> update_tab_data(fn listing_data ->
      new_hover_index = 0

      new_todo_panels =
        listing_data.todo_panels
        |> List.delete_at(listing_data.todo_panel_hover_index)
        |> Enum.map(fn todo_panel -> %{todo_panel | hover: false} end)
        |> List.update_at(new_hover_index, fn todo_panel ->
          %{todo_panel | hover: true}
        end)

      %{listing_data | todo_panels: new_todo_panels, todo_panel_hover_index: new_hover_index}
    end)
  end

  defp panel_navigate(model = %Model{}, :up) do
    model
    |> update_tab_data(fn listing_data ->
      new_hover_index = hover_index_shift_up(listing_data.todo_panel_hover_index)
      todo_panels = panel_set_hover(listing_data.todo_panels, new_hover_index)

      %{listing_data | todo_panels: todo_panels, todo_panel_hover_index: new_hover_index}
    end)
  end

  defp panel_navigate(model = %Model{}, :down) do
    model
    |> update_tab_data(fn listing_data ->
      new_hover_index =
        hover_index_shift_down(listing_data.todo_panel_hover_index, listing_data.todo_panels)

      todo_panels = panel_set_hover(listing_data.todo_panels, new_hover_index)

      %{listing_data | todo_panels: todo_panels, todo_panel_hover_index: new_hover_index}
    end)
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
