defmodule TodoBoard.App.Listing.Update.PanelSelectedTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Listing.Update.PanelSelected
  alias TodoBoard.App.Base.{Model, TodoPanel}

  require Model

  Model.defp__update_tab_data(:listing)

  describe "update/2 - Exit to Normal mode" do
    setup do
      %{event_exit_to_normal: {:event, %{key: key(:esc)}}}
    end

    test "changes `mode` field, and `selected` field on panel", context do
      model = %Model{
        debug_overlay: false,
        selected_tab: :listing,
        tab_data: %Model.TabData{
          listing: %{
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
            ]
          },
          rating: %{}
        },
        mode: :panel_selected,
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = PanelSelected.update(model, context.event_exit_to_normal)

      assert new_model ==
               %{model | mode: :normal}
               |> update_tab_data(fn listing_data ->
                 %{
                   listing_data
                   | todo_panels: [
                       %{first_panel | selected: false},
                       second_panel
                     ]
                 }
               end)
    end
  end

  describe "update/2 - Item navigate up" do
    setup do
      %{event_navigate_up: {:event, %{key: key(:arrow_up)}}}
    end

    test "changes `hover` field on elements, and sets `element_hover_index`", context do
      model = %Model{
        debug_overlay: false,
        selected_tab: :listing,
        mode: :panel_selected,
        tab_data: %Model.TabData{
          listing: %{
            todo_panels: [
              first_panel = %TodoPanel{
                elements: [
                  first_element = %TodoPanel.Element{
                    todo: "First",
                    hover: false,
                    selected: false
                  },
                  second_element = %TodoPanel.Element{
                    todo: "Second",
                    hover: true,
                    selected: false
                  },
                  third_element = %TodoPanel.Element{
                    todo: "Third",
                    hover: false,
                    selected: false
                  }
                ],
                element_hover_index: 1,
                hover: true,
                selected: true
              },
              second_panel = %TodoPanel{elements: [], hover: false, selected: false}
            ]
          },
          rating: %{}
        },
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = PanelSelected.update(model, context.event_navigate_up)

      assert new_model ==
               model
               |> update_tab_data(fn listing_data ->
                 %{
                   listing_data
                   | todo_panels: [
                       %{
                         first_panel
                         | elements: [
                             %{first_element | hover: true},
                             %{second_element | hover: false},
                             third_element
                           ],
                           element_hover_index: 0
                       },
                       second_panel
                     ]
                 }
               end)
    end

    test "does not move `hover` or `element_hover_index` out of bounds", context do
      model = %Model{
        debug_overlay: false,
        selected_tab: :listing,
        mode: :panel_selected,
        tab_data: %Model.TabData{
          listing: %{
            todo_panels: [
              %TodoPanel{
                elements: [
                  %TodoPanel.Element{todo: "First", hover: true, selected: false},
                  %TodoPanel.Element{todo: "Second", hover: false, selected: false}
                ],
                element_hover_index: 0,
                hover: true,
                selected: true
              },
              %TodoPanel{elements: [], hover: false, selected: false}
            ]
          },
          rating: %{}
        },
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = PanelSelected.update(model, context.event_navigate_up)

      assert new_model == model
    end
  end

  describe "update/2 - Item navigate down" do
    setup do
      %{event_navigate_down: {:event, %{key: key(:arrow_down)}}}
    end

    test "changes `hover` field on elements, and sets `element_hover_index`", context do
      model = %Model{
        debug_overlay: false,
        selected_tab: :listing,
        mode: :panel_selected,
        tab_data: %Model.TabData{
          listing: %{
            todo_panels: [
              first_panel = %TodoPanel{
                elements: [
                  first_element = %TodoPanel.Element{
                    todo: "First",
                    hover: false,
                    selected: false
                  },
                  second_element = %TodoPanel.Element{
                    todo: "Second",
                    hover: true,
                    selected: false
                  },
                  third_element = %TodoPanel.Element{
                    todo: "Third",
                    hover: false,
                    selected: false
                  }
                ],
                element_hover_index: 1,
                hover: true,
                selected: true
              },
              second_panel = %TodoPanel{elements: [], hover: false, selected: false}
            ]
          },
          rating: %{}
        },
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = PanelSelected.update(model, context.event_navigate_down)

      assert new_model ==
               model
               |> update_tab_data(fn listing_data ->
                 %{
                   listing_data
                   | todo_panels: [
                       %{
                         first_panel
                         | elements: [
                             first_element,
                             %{second_element | hover: false},
                             %{third_element | hover: true}
                           ],
                           element_hover_index: 2
                       },
                       second_panel
                     ]
                 }
               end)
    end

    test "does not move `hover` or `element_hover_index` out of bounds", context do
      model = %Model{
        debug_overlay: false,
        selected_tab: :listing,
        mode: :panel_selected,
        tab_data: %Model.TabData{
          listing: %{
            todo_panels: [
              %TodoPanel{
                elements: [
                  %TodoPanel.Element{todo: "First", hover: false, selected: false},
                  %TodoPanel.Element{todo: "Second", hover: true, selected: false}
                ],
                element_hover_index: 1,
                hover: true,
                selected: true
              },
              %TodoPanel{elements: [], hover: false, selected: false}
            ]
          },
          rating: %{}
        },
        todos: [],
        window: %{height: 100, width: 100}
      }

      new_model = PanelSelected.update(model, context.event_navigate_down)

      assert new_model == model
    end
  end
end
