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

  import Ratatouille.Constants, only: [key: 1]
  import Ratatouille.View

  alias TodoBoard.App.{Help, Listing}
  alias TodoBoard.App.Update
  alias TodoBoard.App.Base.{Model, TodoPanel}
  alias TodoBoard.Repo

  @all_tab_names [:listing, :help]

  @impl true
  def init(%{window: window}) do
    todos = read_todos()
    starting_panel = TodoPanel.create_from_todos(todos, _hover = true)

    %Model{
      debug_overlay: false,
      selected_tab: :listing,
      tab_data: %Model.TabData{
        listing: %{
          todo_panels: [starting_panel],
          todo_panel_hover_index: 0
        }
      },
      mode: :normal,
      todos: todos,
      window: window
    }
  end

  @impl true
  def update(model, msg) do
    f1 = key(:f1)
    f2 = key(:f2)

    case {model.selected_tab, msg} do
      {_tab, {:resize, resize_data}} ->
        Update.window_resize(model, resize_data)

      {_tab, {:event, %{ch: ?m}}} ->
        %{model | debug_overlay: not model.debug_overlay}

      {_tab, {:event, %{key: ^f1}}} ->
        %{model | selected_tab: :listing}

      {_tab, {:event, %{key: ^f2}}} ->
        %{model | selected_tab: :help}

      {:listing, _msg} ->
        Listing.update(model, msg)

      {:help, _msg} ->
        Help.update(model, msg)
    end
  end

  @impl true
  def render(model) do
    view(bottom_bar: status_bar(model)) do
      case model.selected_tab do
        :listing -> Listing.render(model)
        :help -> Help.render(model)
      end

      debug_overlay(model)
    end
  end

  defp status_bar(model) do
    bar do
      label do
        for tab <- @all_tab_names do
          tab_name = tab |> Atom.to_string() |> String.capitalize()
          content = " #{tab_name} "

          if tab == model.selected_tab do
            text(
              background: :red,
              color: :white,
              content: content
            )
          else
            text(content: content)
          end
        end
      end
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
