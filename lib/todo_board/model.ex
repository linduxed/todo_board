defmodule TodoBoard.Model do
  @enforce_keys [
    :mode,
    :todos,
    :todo_panels,
    :window
  ]
  defstruct [
    :mode,
    :todos,
    :todo_panels,
    :window,
    debug_overlay: false,
    todo_panel_hover_index: 0
  ]
end
