defmodule TodoBoard.App.Update.PanelSelectedTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Update.PanelSelected
  alias TodoBoard.{Model, TodoPanel}

  @escape key(:esc)

  describe "update/2 - Exit to Normal mode" do
    test "changes `mode` field, and `selected` field on panel" do
      model = %Model{
        debug_overlay: false,
        mode: :panel_selected,
        todo_panels: [
          first_panel = %TodoPanel{
            elements: [],
            hover: true,
            selected: true
          },
          second_panel = %TodoPanel{
            elements: [],
            hover: false,
            selected: false
          }
        ],
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = PanelSelected.update(model, {:event, %{key: @escape}})

      assert new_model == %{
               model
               | mode: :normal,
                 todo_panels: [
                   %{first_panel | selected: false},
                   second_panel
                 ]
             }
    end
  end
end
