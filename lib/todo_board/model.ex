defmodule TodoBoard.Model do
  defstruct debug_overlay: false,
            mode: :normal,
            todos: [],
            todo_panels: [],
            window: %{}
end
