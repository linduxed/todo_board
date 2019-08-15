defmodule TodoBoard.App do
  @moduledoc """
  The Ratatouille application
  """

  @behaviour Ratatouille.App

  import Ratatouille.View

  alias Ratatouille.Runtime.Command
  alias TodoBoard.Model

  @todo_file_path Application.get_env(:todo_board, :todo_file)

  @impl true
  def init(%{window: window}) do
    model = %Model{
      debug_overlay: false,
      selected_tab: :priority,
      todos: [],
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
      {:todo_file_read, todo_lines} ->
        %{model | todos: todo_lines}

      {:event, %{ch: ?m}} ->
        %{model | debug_overlay: not model.debug_overlay}

      _msg ->
        model
    end
  end

  @impl true
  def render(model) do
    view do
      row do
        column(size: 12) do
          panel(title: "TODOs", height: :fill) do
            table do
              for todo_line <- model.todos do
                table_row do
                  table_cell(content: todo_line)
                end
              end
            end
          end
        end
      end

      debug_overlay(model)
    end
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
