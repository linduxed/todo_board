defmodule TodoBoard.App.Update.NormalTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Update.Normal
  alias TodoBoard.{Model, TodoPanel}

  describe "update/2 - Panel navigate down" do
    setup do
      %{event_navigate_down: {:event, %{key: key(:arrow_down)}}}
    end

    test "changes `hover` field on panels", context do
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
        todo_panel_hover_index: 0,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_navigate_down)

      assert new_model == %{
               model
               | todo_panels: [
                   %{first_panel | hover: false},
                   %{second_panel | hover: true}
                 ],
                 todo_panel_hover_index: 1
             }
    end

    test "does nothing if last panel is hovered over", context do
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
        todo_panel_hover_index: 1,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_navigate_down)

      assert new_model == model
    end
  end

  describe "update/2 - Panel navigate up" do
    setup do
      %{event_navigate_up: {:event, %{key: key(:arrow_up)}}}
    end

    test "changes `hover` field on panels", context do
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
        todo_panel_hover_index: 1,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_navigate_up)

      assert new_model == %{
               model
               | todo_panels: [
                   %{first_panel | hover: true},
                   %{second_panel | hover: false}
                 ],
                 todo_panel_hover_index: 0
             }
    end

    test "does nothing if first panel is hovered over", context do
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
        todo_panel_hover_index: 0,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_navigate_up)

      assert new_model == model
    end
  end

  describe "update/2 - Select panel" do
    setup do
      %{event_select_panel: {:event, %{key: key(:enter)}}}
    end

    test "changes `mode`, and `selected` field on panel", context do
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
        todo_panel_hover_index: 0,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_select_panel)

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

  describe "update/2 - Add panel" do
    setup do
      %{event_add_panel: {:event, %{ch: ?p}}}
    end

    test "adds panel and adjusts panel hover index", context do
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
        todo_panel_hover_index: 1,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_add_panel)

      new_panel = %TodoPanel{
        elements: [],
        hover: true,
        selected: false
      }

      assert new_model == %{
               model
               | mode: :normal,
                 todo_panels: [
                   new_panel,
                   first_panel,
                   %{second_panel | hover: false}
                 ],
                 todo_panel_hover_index: 0
             }
    end
  end

  describe "update/2 - Remove panel" do
    setup do
      %{event_remove_panel: {:event, %{ch: ?x}}}
    end

    test "removes hovered over panel and adjusts panel hover index", context do
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
            hover: false,
            selected: false
          },
          _hovered_panel = %TodoPanel{
            elements: [],
            hover: true,
            selected: false
          }
        ],
        todo_panel_hover_index: 2,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = Normal.update(model, context.event_remove_panel)

      assert new_model == %{
               model
               | mode: :normal,
                 todo_panels: [
                   %{first_panel | hover: true},
                   second_panel
                 ],
                 todo_panel_hover_index: 0
             }
    end
  end
end
