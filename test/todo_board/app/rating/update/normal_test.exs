defmodule TodoBoard.App.Rating.Update.NormalTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Rating.Update.Normal
  alias TodoBoard.App.Base.Model

  require Model

  Model.defp__update_tab_data(:rating)

  describe "update/2 - Hover left todo" do
    setup do
      %{event_hover_left: {:event, %{key: key(:arrow_left)}}}
    end

    test "changes `hover` field on todo panels"
    test "does nothing if left todo panel is hovered over"
  end

  describe "update/2 - Hover right todo" do
    setup do
      %{event_hover_right: {:event, %{key: key(:arrow_right)}}}
    end
    test "changes `hover` field on todo panels"
    test "does nothing if right todo panel is hovered over"
  end

  describe "update/2 - Hover draw button" do
    setup do
      %{event_hover_draw: {:event, %{key: key(:arrow_down)}}}
    end

    test "changes `hover` field on todo panels and on draw button"
    test "does nothing if draw button is hovered over"
  end

  describe "update/2 - Choose hovered over todo" do
    setup do
      %{event_choose_todo: {:event, %{key: key(:space)}}}
    end

    test "updates ratings of competing todos"
  end
end
