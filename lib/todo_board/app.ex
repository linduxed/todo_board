defmodule TodoBoard.App do
  @moduledoc """
  The Ratatouille application
  """

  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [attribute: 1, color: 1, key: 1]

  import Ratatouille.View

  alias Ratatouille.Runtime.Command
  alias TodoBoard.{Model, TodoPanel}

  @todo_file_path Application.get_env(:todo_board, :todo_file)

  @impl true
  def init(%{window: window}) do
    model = %Model{
      debug_overlay: false,
      selected_tab: :priority,
      todos: [],
      todo_panels: [],
      window: window
    }

    {
      model,
      Command.new(&read_todo_file_lines/0, :todo_file_read)
    }
  end

  @impl true
  def update(model, msg) do
    case msg do
      {:resize, %{h: height, w: width}} ->
        %{model | window: %{height: height, width: width}}

      {:todo_file_read, todo_lines} ->
        %{model | todos: todo_lines}

      {:event, %{ch: ?m}} ->
        %{model | debug_overlay: not model.debug_overlay}

      {:event, %{ch: ?p}} ->
        panel_elements = Enum.map(model.todos, fn todo -> %TodoPanel.Element{todo: todo} end)

        new_todo_panel = %TodoPanel{elements: panel_elements, selected: false}

        %{model | todo_panels: [new_todo_panel | model.todo_panels]}

      {:event, %{ch: ?x}} ->
        new_todo_panels =
          case model.todo_panels do
            [] -> model.todo_panels
            [_ | rest] -> rest
          end

        %{model | todo_panels: new_todo_panels}

      _msg ->
        model
    end
  end

  @impl true
  def render(model) do
    panel_height = even_vertical_split_panel_height(model)

    view do
      row do
        column(size: 12) do
          for todo_panel <- model.todo_panels do
            panel(title: "TODOs", height: panel_height, color: :red) do
              table do
                for element <- todo_panel.elements do
                  table_row do
                    table_cell(content: element.todo)
                  end
                end
              end
            end
          end
        end
      end

      debug_overlay(model)
    end
  end

  defp even_vertical_split_panel_height(%Model{todo_panels: []}), do: nil

  defp even_vertical_split_panel_height(%Model{
         todo_panels: todo_panels,
         window: %{height: window_height}
       }) do
    floor(window_height / length(todo_panels))
  end

  defp debug_overlay(%Model{debug_overlay: false}), do: nil

  defp debug_overlay(model = %Model{debug_overlay: true}) do
    padding = 5
    overlay_border_width = 1

    overlay_height =
      model.window.height -
        2 * padding -
        2 * overlay_border_width

    truncated_model =
      model
      |> inspect(pretty: true)
      |> String.split("\n")
      |> Enum.take(overlay_height)
      |> Enum.join("\n")

    overlay(padding: padding) do
      panel(title: "Model data") do
        label(content: truncated_model)
      end
    end
  end

  defp read_todo_file_lines() do
    @todo_file_path
    |> File.read!()
    |> String.split("\n")
  end
end
