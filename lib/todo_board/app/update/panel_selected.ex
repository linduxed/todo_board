defmodule TodoBoard.App.Update.PanelSelected do
  @moduledoc """
  Update actions for the cases where a panel has been selected.
  """

  def return_to_normal_mode(model = %Model{}) do
    panels_no_selected = Enum.map(model.todo_panels, &%{&1 | selected: false})

    %{model | mode: :normal, todo_panels: panels_no_selected}
  end
end
