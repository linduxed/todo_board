defmodule TodoBoard.Model do
  defstruct debug_overlay: false,
            selected_tab: :priority,
            todos: [],
            window: %{}
end
