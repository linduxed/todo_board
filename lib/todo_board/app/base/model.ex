defmodule TodoBoard.App.Base.Model do
  @moduledoc """
  Defines the state of the application

  The `Model` houses all/most of the information that the application uses. It
  used for rendering the views, and is updated by the `Update` modules for the
  next rendering iteration.
  """

  @enforce_keys [
    :selected_tab,
    :tab_data,
    :mode,
    :todos,
    :window
  ]
  defstruct [
    :selected_tab,
    :tab_data,
    :mode,
    :todos,
    :window,
    debug_overlay: false,
    todo_panel_hover_index: 0
  ]

  defmacro defp__update_tab_data(tab_name) do
    quote do
      defp update_tab_data(model = %TodoBoard.App.Base.Model{}, update_fun) do
        data = model.tab_data.unquote(tab_name)

        %{model | tab_data: %{model.tab_data | unquote(tab_name) => update_fun.(data)}}
      end
    end
  end
end
