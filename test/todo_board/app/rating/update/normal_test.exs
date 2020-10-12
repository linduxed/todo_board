defmodule TodoBoard.App.Rating.Update.NormalTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Rating.Update.Normal
  alias TodoBoard.App.Base.Model
  alias TodoBoard.Factory

  require Model

  Model.defp__update_tab_data(:rating)

  describe "update/2 - Hover left todo" do
    setup do
      %{event_hover_left: {:event, %{key: key(:arrow_left)}}}
    end

    test "changes `hover` field on todo panels", context do
      todos = Factory.build_list(3, :todo, %{status: "pending"})

      model =
        Factory.build(:model,
          rating_tab_data:
            Factory.build(
              :rating_tab_data,
              choice: :none,
              todos: todos
            ),
          todos: todos
        )

      new_model = Normal.update(model, context.event_hover_left)

      assert new_model ==
               model
               |> update_tab_data(fn rating_data ->
                 rating_data
                 |> put_in([:left, :hover], true)
                 |> put_in([:right, :hover], false)
                 |> put_in([:draw, :hover], false)
                 |> put_in([:choice], :left)
               end)
    end

    test "does nothing if left todo panel is hovered over", context do
      todos = Factory.build_list(3, :todo, %{status: "pending"})

      model =
        Factory.build(:model,
          rating_tab_data:
            Factory.build(
              :rating_tab_data,
              choice: :left,
              todos: todos
            ),
          todos: todos
        )

      new_model = Normal.update(model, context.event_hover_left)

      assert new_model == model
    end
  end

  describe "update/2 - Hover right todo" do
    setup do
      %{event_hover_right: {:event, %{key: key(:arrow_right)}}}
    end

    test "changes `hover` field on todo panels", context do
      todos = Factory.build_list(3, :todo, %{status: "pending"})

      model =
        Factory.build(:model,
          rating_tab_data:
            Factory.build(
              :rating_tab_data,
              choice: :none,
              todos: todos
            ),
          todos: todos
        )

      new_model = Normal.update(model, context.event_hover_right)

      assert new_model ==
               model
               |> update_tab_data(fn rating_data ->
                 rating_data
                 |> put_in([:left, :hover], false)
                 |> put_in([:right, :hover], true)
                 |> put_in([:draw, :hover], false)
                 |> put_in([:choice], :right)
               end)
    end

    test "does nothing if right todo panel is hovered over", context do
      todos = Factory.build_list(3, :todo, %{status: "pending"})

      model =
        Factory.build(:model,
          rating_tab_data:
            Factory.build(
              :rating_tab_data,
              choice: :right,
              todos: todos
            ),
          todos: todos
        )

      new_model = Normal.update(model, context.event_hover_right)

      assert new_model == model
    end
  end

  describe "update/2 - Hover draw button" do
    setup do
      %{event_hover_draw: {:event, %{key: key(:arrow_down)}}}
    end

    test "changes `hover` field on todo panels and on draw button", context do
      todos = Factory.build_list(3, :todo, %{status: "pending"})

      model =
        Factory.build(:model,
          rating_tab_data:
            Factory.build(
              :rating_tab_data,
              choice: :none,
              todos: todos
            ),
          todos: todos
        )

      new_model = Normal.update(model, context.event_hover_draw)

      assert new_model ==
               model
               |> update_tab_data(fn rating_data ->
                 rating_data
                 |> put_in([:left, :hover], false)
                 |> put_in([:right, :hover], false)
                 |> put_in([:draw, :hover], true)
                 |> put_in([:choice], :draw)
               end)
    end
    test "does nothing if draw button is hovered over", context do
      todos = Factory.build_list(3, :todo, %{status: "pending"})

      model =
        Factory.build(:model,
          rating_tab_data:
            Factory.build(
              :rating_tab_data,
              choice: :draw,
              todos: todos
            ),
          todos: todos
        )

      new_model = Normal.update(model, context.event_hover_draw)

      assert new_model == model
    end
  end

  describe "update/2 - Choose hovered over todo" do
    setup do
      %{event_choose_todo: {:event, %{key: key(:space)}}}
    end

    test "updates ratings of competing todos"
  end
end
