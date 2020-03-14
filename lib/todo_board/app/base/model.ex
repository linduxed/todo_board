defmodule TodoBoard.App.Base.Model do
  @moduledoc """
  Defines the state of the application

  The `Model` houses all/most of the information that the application uses. It
  used for rendering the views, and is updated by the `Update` modules for the
  next rendering iteration.
  """

  @enforce_keys [
    :tab,
    :mode,
    :todos,
    :todo_panels,
    :window
  ]
  defstruct [
    :tab,
    :mode,
    :todos,
    :todo_panels,
    :window,
    debug_overlay: false,
    todo_panel_hover_index: 0
  ]
end
