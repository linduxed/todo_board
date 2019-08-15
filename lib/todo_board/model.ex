defmodule TodoBoard.Model do
  defstruct debug_overlay: false,
            panel_selected?: false,
            selected_tab: :priority,
            todos: [],
            todo_panels: [],
            window: %{}
end
