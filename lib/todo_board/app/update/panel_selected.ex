defmodule TodoBoard.App.Update.PanelSelected do
  @moduledoc """
  Update actions for the cases where a panel has been selected.
  """

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.Model

  @escape key(:esc)

  def update(model = %Model{}, msg) do
    case msg do
      {:event, %{key: @escape}} -> return_to_normal_mode(model)
      _msg -> model
    end
  end

  defp return_to_normal_mode(model = %Model{}) do
    panels_no_selected = Enum.map(model.todo_panels, &%{&1 | selected: false})

    %{model | mode: :normal, todo_panels: panels_no_selected}
  end
end
