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
      overlay: nil,
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
    end
  end

  defp read_todo_file_lines() do
    @todo_file_path
    |> File.read!()
    |> String.split("\n")
  end
end
