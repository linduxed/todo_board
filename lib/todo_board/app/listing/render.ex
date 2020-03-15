defmodule TodoBoard.App.Listing.Render do
  @moduledoc """
  Responsible for generating all of the Listing related view elements
  """

  import Ratatouille.Constants, only: [attribute: 1, color: 1]
  import Ratatouille.View

  alias TodoBoard.App.Base.{Model, TodoPanel}
  alias TodoBoard.Todo

  def render(model) do
    panel_height = even_vertical_split_panel_height(model)

    row do
      column(size: 12) do
        for todo_panel <- model.tab_data.listing.todo_panels do
          panel(
            title: panel_title(todo_panel),
            height: panel_height,
            color: panel_color(todo_panel)
          ) do
            table do
              for element <- todo_panel.elements do
                table_row do
                  table_cell(
                    attributes: element_attributes(element, todo_panel.selected),
                    background: element_background(element, todo_panel.selected),
                    content: render_todo(element.todo)
                  )
                end
              end
            end
          end
        end
      end
    end
  end

  defp panel_title(%TodoPanel{elements: elements}) do
    "TODOs: #{length(elements)}"
  end

  defp panel_color(%TodoPanel{selected: true}), do: color(:green)
  defp panel_color(%TodoPanel{hover: true}), do: color(:red)
  defp panel_color(%TodoPanel{hover: _}), do: nil

  defp element_attributes(%TodoPanel.Element{hover: true}, _panel_selected = true),
    do: [attribute(:bold)]

  defp element_attributes(_element, _panel_selected), do: nil

  defp element_background(%TodoPanel.Element{hover: true}, _panel_selected = true),
    do: color(:red)

  defp element_background(_element, _panel_selected), do: nil

  defp even_vertical_split_panel_height(%Model{tab_data: %{listing: %{todo_panels: []}}}), do: nil

  defp even_vertical_split_panel_height(%Model{
         tab_data: %{
           listing: %{
             todo_panels: todo_panels
           }
         },
         window: %{height: window_height}
       }) do
    # Subtract 1 to ensure space for tab listing
    floor(window_height / length(todo_panels)) - 1
  end

  defp render_todo(todo = %Todo{}) do
    project_string =
      if todo.project do
        "<" <> "#{todo.project}" <> "> "
      else
        ""
      end

    tag_string =
      case todo.tags do
        [] -> ""
        tags -> "[" <> Enum.join(tags, ", ") <> "] "
      end

    "#{project_string}#{tag_string}#{todo.description}"
  end
end
