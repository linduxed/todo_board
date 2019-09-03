defmodule TodoBoard.App.Update.NormalTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Update.Normal
  alias TodoBoard.{Model, TodoPanel}

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  @enter key(:enter)

  describe "update/2 - Panel navigate down" do
    test "changes `hover` field on panels" do
      model = %Model{
        debug_overlay: false,
        mode: :normal,
        todo_panels: [
          first_panel = %TodoPanel{
            elements: [],
            hover: true,
            selected: false
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

      new_model = Normal.update(model, {:event, %{key: @arrow_down}})

      assert new_model == %{
               model
               | todo_panels: [
                   %{first_panel | hover: false},
                   %{second_panel | hover: true}
                 ]
             }
    end

    test "does nothing if last panel is hovered over" do
      model = %Model{
        debug_overlay: false,
        mode: :normal,
        todo_panels: [
          %TodoPanel{
            elements: [],
            hover: false,
            selected: false
          },
          %TodoPanel{
            elements: [],
            hover: true,
            selected: false
          }
        ],
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, {:event, %{key: @arrow_down}})

      assert new_model == model
    end
  end

  describe "update/2 - Panel navigate up" do
    test "changes `hover` field on panels" do
      model = %Model{
        debug_overlay: false,
        mode: :normal,
        todo_panels: [
          first_panel = %TodoPanel{
            elements: [],
            hover: false,
            selected: false
          },
          second_panel = %TodoPanel{
            elements: [],
            hover: true,
            selected: false
          }
        ],
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, {:event, %{key: @arrow_up}})

      assert new_model == %{
               model
               | todo_panels: [
                   %{first_panel | hover: true},
                   %{second_panel | hover: false}
                 ]
             }
    end

    test "does nothing if first panel is hovered over" do
      model = %Model{
        debug_overlay: false,
        mode: :normal,
        todo_panels: [
          %TodoPanel{
            elements: [],
            hover: true,
            selected: false
          },
          %TodoPanel{
            elements: [],
            hover: false,
            selected: false
          }
        ],
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, {:event, %{key: @arrow_up}})

      assert new_model == model
    end
  end

  describe "update/2 - Select panel" do
    test "changes `mode`, and `selected` field on panel" do
      model = %Model{
        debug_overlay: false,
        mode: :normal,
        todo_panels: [
          first_panel = %TodoPanel{
            elements: [],
            hover: true,
            selected: false
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

      new_model = Normal.update(model, {:event, %{key: @enter}})

      assert new_model == %{
               model
               | mode: :panel_selected,
                 todo_panels: [
                   %{first_panel | selected: true},
                   second_panel
                 ]
             }
    end
  end
end
