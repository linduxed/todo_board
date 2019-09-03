defmodule TodoBoard.Model do
  defstruct debug_overlay: false,
            mode: :normal,
            todos: [],
            todo_panels: [],
            todo_panel_hover_index: 0,
            window: %{}
end
