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

  import Ratatouille.View

  alias TodoBoard.App.Listing
  alias TodoBoard.App.Update
  alias TodoBoard.{Model, Repo, TodoPanel}

  @impl true
  def init(%{window: window}) do
    todos = read_todos()

    model = %Model{
      debug_overlay: false,
      tab: :listing,
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
    case {model.tab, msg} do
      {_tab, {:resize, resize_data}} ->
        Update.window_resize(model, resize_data)

      {_tab, {:event, %{ch: ?m}}} ->
        %{model | debug_overlay: not model.debug_overlay}

      {:listing, _msg} ->
        Listing.update(model, msg)
    end
  end

  @impl true
  def render(model) do
    view do
      Listing.render(model)

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

  defp read_todos do
    {:ok, todos} = Repo.TaskWarrior.read_all()
    todos
  end
end
