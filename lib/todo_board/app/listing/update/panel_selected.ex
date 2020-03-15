defmodule TodoBoard.App.Listing.Update.PanelSelected do
  @moduledoc """
  Update actions for the cases where a panel has been selected.
  """

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Base.{Model, TodoPanel}

  require Model

  Model.defp__update_tab_data(:listing)

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
    %{model | mode: :normal}
    |> update_tab_data(fn listing_data ->
      panels_no_selected = Enum.map(listing_data.todo_panels, &%{&1 | selected: false})

      %{listing_data | todo_panels: panels_no_selected}
    end)
  end

  defp todo_navigate(model = %Model{}, direction) when direction in [:up, :down] do
    model
    |> update_tab_data(fn listing_data ->
      new_todo_panels =
        update_selected_panel(listing_data.todo_panels, fn todo_panel ->
          new_hover_index = shifted_hover_index(todo_panel, direction)
          new_elements = move_hover_to(todo_panel.elements, new_hover_index)

          %{todo_panel | elements: new_elements, element_hover_index: new_hover_index}
        end)

      %{listing_data | todo_panels: new_todo_panels}
    end)
  end

  defp shifted_hover_index(%TodoPanel{elements: []}, _direction), do: 0
  defp shifted_hover_index(%TodoPanel{element_hover_index: 0}, _direction = :up), do: 0

  defp shifted_hover_index(%TodoPanel{element_hover_index: element_hover_index}, _direction = :up) do
    element_hover_index - 1
  end

  defp shifted_hover_index(
         %TodoPanel{elements: elements, element_hover_index: element_hover_index},
         _direction = :down
       ) do
    index_bottom_boundary = length(elements) - 1

    case element_hover_index == index_bottom_boundary do
      true -> element_hover_index
      false -> element_hover_index + 1
    end
  end

  defp move_hover_to(elements, index) do
    elements
    |> Enum.map(&%{&1 | hover: false})
    |> List.update_at(index, fn todo_panel -> %{todo_panel | hover: true} end)
  end

  defp update_selected_panel(list, update_fun) do
    position_to_update =
      Enum.find_index(list, fn todo_panel ->
        match?(%TodoPanel{selected: true}, todo_panel)
      end)

    List.update_at(list, position_to_update, update_fun)
  end
end
