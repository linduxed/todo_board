defmodule TodoBoard.App.Rating.Render do
  @moduledoc """
  Responsible for generating all of the Listing related view elements
  """

  import Ratatouille.Constants, only: [attribute: 1, color: 1]
  import Ratatouille.View

  alias TodoBoard.App.Base.{Model}
  alias TodoBoard.Todo

  def render(model) do
    panel(title: "Rating") do
      row do
        column(size: 12) do
          panel(title: "Top TODOs (out of #{Enum.count(model.todos)})") do
            table do
              for todo <- model.tab_data.rating.top_rated do
                table_row do
                  table_cell(content: todo_rating(todo))
                  table_cell(content: "--")
                  table_cell(content: todo_project(todo))
                  table_cell(content: todo_tags(todo))
                  table_cell(content: "--")
                  table_cell(content: todo_description(todo))
                end
              end
            end
          end
        end
      end

      row do
        for {side, panel_title} <- [
              {model.tab_data.rating.left, "Left"},
              {model.tab_data.rating.right, "Right"}
            ] do
          column(size: 6) do
            panel(title: panel_title, color: panel_color(side)) do
              table do
                table_row do
                  table_cell(content: "Description:")
                  table_cell(content: todo_description(side.todo))
                end

                table_row do
                  table_cell(content: "Project:")
                  table_cell(content: todo_project(side.todo))
                end

                table_row do
                  table_cell(content: "Tags:")
                  table_cell(content: todo_tags(side.todo))
                end

                table_row do
                  table_cell(content: "Rating:")
                  table_cell(content: todo_rating(side.todo))
                end
              end
            end
          end
        end
      end

      row do
        column(size: 12) do
          panel do
            table do
              table_row do
                table_cell(
                  content: "Draw",
                  color: panel_color(model.tab_data.rating.draw)
                )
              end
            end
          end
        end
      end

      row do
        column(size: 12) do
          panel do
            table do
              table_row do
                table_cell(content: "Total results: #{count_results(model.todos)}")
              end
            end
          end
        end
      end
    end
  end

  defp count_results(todos) do
    todos |> Enum.flat_map(& &1.rating.results) |> Enum.count()
  end

  defp panel_color(%{hover: true}), do: color(:red)
  defp panel_color(%{hover: _}), do: nil

  defp todo_rating(todo) do
    # TODO: implement String.Chars protocol instead
    todo.rating.player
    |> Glicko.Player.to_v1()
    |> Map.fetch!(:rating)
    |> ceil()
    |> inspect()
  end

  defp todo_project(todo) do
    project = if todo.project, do: todo.project, else: ""
    "<" <> project <> ">"
  end

  defp todo_tags(todo) do
    case todo.tags do
      [] -> "[]"
      tags -> "[" <> Enum.join(tags, ", ") <> "]"
    end
  end

  defp todo_description(todo) do
    todo.description
  end
end
