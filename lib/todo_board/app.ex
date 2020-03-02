defmodule TodoBoard.App do
  @moduledoc """
  Standard [Ratatouille][1] application, following the Model-Update-View structure.

  Some inspiration for the application structure is drawn from the [Toby][2]
  application (written by the author of the [Ratatouille][1] library).

    [1]: https://github.com/ndreynolds/ratatouille
    [2]: https://github.com/ndreynolds/toby

  The application makes a couple assumptions about the model contents. These
  assumptions are generally not checked, so if something is wrong then the
  application may crash.

  Checks and tests should maybe be added later, but for now the programmer
  simply has to keep these assumptions in mind when modifying the code.

  ### Assumptions

    * There is always at least one TODO panel present.
    * Only one of the panels can have the `hover` key set to `true`.
    * Only one of the panels can have the `selected` key set to `true`.
  """

  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [attribute: 1, color: 1]

  import Ratatouille.View

  alias TodoBoard.App.Update
  alias TodoBoard.{Model, Todo, TodoPanel}

  @impl true
  def init(%{window: window}) do
    todos = read_todos()

    model = %Model{
      debug_overlay: false,
      mode: :normal,
      todos: todos,
      todo_panels: [],
      todo_panel_hover_index: 0,
      window: window
    }

    starting_panel = TodoPanel.create_from_todos(model.todos, _hover = true)

    %{model | todo_panels: [starting_panel]}
  end

  @impl true
  def update(model, msg) do
    case {model.mode, msg} do
      {_mode, {:resize, resize_data}} ->
        Update.window_resize(model, resize_data)

      {_mode, {:event, %{ch: ?m}}} ->
        %{model | debug_overlay: not model.debug_overlay}

      {:normal, _msg} ->
        Update.Normal.update(model, msg)

      {:panel_selected, _msg} ->
        Update.PanelSelected.update(model, msg)
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

      debug_overlay(model)
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

  defp even_vertical_split_panel_height(%Model{todo_panels: []}), do: nil

  defp even_vertical_split_panel_height(%Model{
         todo_panels: todo_panels,
         window: %{height: window_height}
       }) do
    floor(window_height / length(todo_panels))
  end

  defp render_todo(todo = %Todo{}) do
    todo.description
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

  defp read_todos() do
    {:ok, todos} = TodoBoard.Repo.TaskWarrior.read_all()
    todos
  end
end
