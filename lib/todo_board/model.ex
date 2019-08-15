defmodule TodoBoard.Model do
  defstruct debug_overlay: false,
            panel_selected?: false,
            todos: [],
            todo_panels: [],
            window: %{}
end
