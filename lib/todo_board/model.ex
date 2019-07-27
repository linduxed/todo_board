defmodule TodoBoard.Model do
  defstruct overlay: nil,
            selected_tab: :priority,
            todos: [],
            window: %{}
end
