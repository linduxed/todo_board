defmodule TodoBoard.Factory do
  use ExMachina

  alias TodoBoard.{
    App.Base.Model,
    Rating,
    Todo
  }

  def model_factory(attrs) do
    {todos, attrs} =
      Map.pop(
        attrs,
        :todos,
        build_list(10, :todo, %{status: "pending"})
      )

    {listing_tab_data, attrs} = Map.pop(attrs, :listing_tab_data, :uninitialized)
    {rating_tab_data, attrs} = Map.pop(attrs, :rating_tab_data, :uninitialized)
    {selected_tab, attrs} = Map.pop(attrs, :selected_tab, :listing)

    selected_tab =
      if selected_tab in [:listing, :rating, :help] do
        selected_tab
      else
        :listing
      end

    model = %Model{
      debug_overlay: false,
      selected_tab: selected_tab,
      tab_data: %Model.TabData{
        listing: listing_tab_data,
        rating: rating_tab_data
      },
      mode: :normal,
      todos: todos,
      window: %{height: 100, width: 100}
    }

    merge_attributes(model, attrs)
  end

  def rating_tab_data_factory(attrs) do
    {todos, attrs} =
      Map.pop(
        attrs,
        :todos,
        build_list(10, :todo, %{status: "pending"})
      )

    {[left, right], other_todos} =
      todos
      |> Enum.filter(&(&1.status == "pending"))
      |> Enum.shuffle()
      |> Enum.split(2)

    {choice, attrs} = Map.pop(attrs, :choice)

    {left_hover, right_hover, draw_hover} =
      case choice do
        :left -> {true, false, false}
        :right -> {false, true, false}
        :draw -> {false, false, true}
        _ -> {false, false, false}
      end

    choice =
      if choice in [:left, :right, :draw, :none] do
        choice
      else
        :none
      end

    tab_data = %{
      top_rated: [],
      left: %{hover: left_hover, todo: left},
      right: %{hover: right_hover, todo: right},
      draw: %{hover: draw_hover},
      other_todos: other_todos,
      choice: choice
    }

    merge_attributes(tab_data, attrs)
  end

  def rating_factory do
    %Rating{
      player: %Glicko.Player.V2{},
      results: []
    }
  end

  def todo_factory do
    one_week_from_now =
      DateTime.utc_now()
      |> DateTime.add(_week_in_seconds = 7 * 24 * 60 * 60, :second)

    one_day_ago =
      DateTime.utc_now()
      |> DateTime.add(_day_ago_in_seconds = -1 * 24 * 60 * 60, :second)

    ten_minutes_ago =
      DateTime.utc_now()
      |> DateTime.add(_ten_minutes_ago_in_seconds = -1 * 10 * 60, :second)

    %Todo{
      description: sequence("Description #"),
      due_date: one_week_from_now,
      project: "default",
      rating: build(:rating),
      source_data: %{},
      status: "pending",
      tags: ["red", "blue"],
      uuid: sequence("UUID-"),
      completed_at: nil,
      inserted_at: one_day_ago,
      updated_at: ten_minutes_ago
    }
  end
end
