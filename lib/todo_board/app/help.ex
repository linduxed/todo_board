defmodule TodoBoard.App.Help do
  @moduledoc """
  Top-level module for the domain of showing help

  This module acts as the entrypoint for showing the help screen.
  """

  import Ratatouille.Constants, only: [attribute: 1]
  import Ratatouille.View

  @bold attribute(:bold)

  def update(model, _msg) do
    model
  end

  def render(_model) do
    row do
      column(size: 12) do
        panel(title: " Help - todo_board (#{TodoBoard.version()}) ") do
          label(content: "Keyboard Controls", attributes: [@bold])
          label()
          control_label("Ctrl-C", "Quit")
          label()
          label(content: "Tabs / Panes")
          control_label("F1 ", "Listing (Display of TODOs)")
          control_label("F2 ", "Help    (This screen)")
          label()
          label(content: "Tab: Listing - No panel selected")
          control_label("UP/DOWN ", "Move up/down between panels")
          control_label("p       ", "Split screen into additional panel")
          control_label("x       ", "Remove hovered over panel")
          label()
          label(content: "Tab: Listing - Panel selected")
          control_label("UP/DOWN ", "Move up/down between TODO items")
          control_label("p       ", "Split screen into additional panel")
          control_label("x       ", "Remove hovered over panel")
          control_label("ESC     ", "De-select panel")
        end
      end
    end
  end

  def control_label(keys, description) do
    label do
      text(attributes: [@bold], content: "  #{keys}")
      text(content: "   #{description}")
    end
  end
end
