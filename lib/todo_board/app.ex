defmodule TodoBoard.App do
  @moduledoc """
  The Ratatouille application
  """

  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [attribute: 1, color: 1, key: 1]

  import Ratatouille.View

  alias Ratatouille.Runtime.Command
  alias TodoBoard.{Model, TodoPanel}
  alias TodoBoard.App.Update

  @todo_file_path Application.get_env(:todo_board, :todo_file)

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  @enter key(:enter)
  @escape key(:esc)

  @impl true
  def init(%{window: window}) do
    model = %Model{
      debug_overlay: false,
      panel_selected?: false,
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
    case {model, msg} do
      {_model, {:resize, resize_data}} ->
        Update.window_resize(model, resize_data)

      {_model, {:todo_file_read, todo_lines}} ->
        %{model | todos: todo_lines}

      {_model, {:event, %{ch: ?m}}} ->
        %{model | debug_overlay: not model.debug_overlay}

      {%{panel_selected?: false}, {:event, %{key: @enter}}} ->
        panels_with_hovered_panel_selected =
          Enum.map(model.todo_panels, fn
            todo_panel = %{hover: true} -> %{todo_panel | selected: true}
            todo_panel -> todo_panel
          end)

        %{model | panel_selected?: true, todo_panels: panels_with_hovered_panel_selected}

      {%{panel_selected?: true}, {:event, %{key: @escape}}} ->
        panels_no_selected =
          Enum.map(model.todo_panels, & %{&1 | selected: false})

        %{model | panel_selected?: true, todo_panels: panels_no_selected}

      {_model, {:event, %{ch: ?p}}} ->
        panel_elements = Enum.map(model.todos, fn todo -> %TodoPanel.Element{todo: todo} end)

        new_todo_panel = %TodoPanel{elements: panel_elements, hover: true, selected: false}

        current_todo_panels =
          Enum.map(model.todo_panels, fn todo_panel ->
            %{todo_panel | hover: false}
          end)

        %{model | todo_panels: [new_todo_panel | current_todo_panels]}

      {_model, {:event, %{ch: ?x}}} ->
        new_todo_panels =
          case model.todo_panels do
            [] ->
              []

            [_single_panel] ->
              []

            [%TodoPanel{hover: true} | [first_remaining_panel | rest]] ->
              [%{first_remaining_panel | hover: true} | rest]

            [_dropped_panel | rest] ->
              rest
          end

        %{model | todo_panels: new_todo_panels}

      {_model, {:event, %{key: key}}} when key in [@arrow_down, @arrow_up] ->
        todo_panels =
          case key do
            @arrow_down -> panel_hover_shift_forward(model.todo_panels)
            @arrow_up -> panel_hover_shift_backward(model.todo_panels)
          end

        %{model | todo_panels: todo_panels}

      {_model, _msg} ->
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
            panel(
              title: panel_title(todo_panel),
              height: panel_height,
              color: panel_color(todo_panel)
            ) do
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

  defp panel_title(%TodoPanel{elements: elements}) do
    "TODOs: #{length(elements)}"
  end

  defp panel_color(%TodoPanel{selected: true}), do: :green
  defp panel_color(%TodoPanel{hover: true}), do: :red
  defp panel_color(%TodoPanel{hover: _}), do: nil

  defp even_vertical_split_panel_height(%Model{todo_panels: []}), do: nil

  defp even_vertical_split_panel_height(%Model{
         todo_panels: todo_panels,
         window: %{height: window_height}
       }) do
    floor(window_height / length(todo_panels))
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
