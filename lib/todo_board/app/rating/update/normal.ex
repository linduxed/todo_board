defmodule TodoBoard.App.Rating.Update.Normal do
  @moduledoc """
  FIXME: add documentation

  Update actions for when no panel is selected.
  """

  import Ratatouille.Constants, only: [key: 1]

  alias TodoBoard.App.Base.Model
  alias TodoBoard.{Rating, Todo}

  require Model

  Model.defp__update_tab_data(:rating)

  @arrow_left key(:arrow_left)
  @arrow_right key(:arrow_right)
  @arrow_down key(:arrow_down)
  @space key(:space)

  def update(model = %Model{}, msg) do
    case msg do
      {:event, %{key: @arrow_left}} -> hover_choice(model, :left)
      {:event, %{key: @arrow_right}} -> hover_choice(model, :right)
      {:event, %{key: @arrow_down}} -> hover_choice(model, :draw)
      {:event, %{key: @space}} -> confirm_choice(model)
      _msg -> model
    end
  end

  defp hover_choice(model = %Model{}, choice) when choice in [:left, :right, :draw] do
    [:left, :right, :draw]
    |> Enum.reduce(model, fn alternative, updated_model ->
      update_tab_data(updated_model, fn rating_data ->
        new_hover_state = alternative == choice

        %{rating_data | alternative => %{rating_data[alternative] | hover: new_hover_state}}
      end)
    end)
    |> update_tab_data(fn rating_data -> %{rating_data | choice: choice} end)
  end

  defp confirm_choice(model = %Model{tab_data: %{rating: %{choice: :none}}}), do: model

  defp confirm_choice(model = %Model{}) do
    choice = model.tab_data.rating.choice
    left_todo = model.tab_data.rating.left.todo
    right_todo = model.tab_data.rating.right.todo
    other_todos = model.tab_data.rating.other_todos

    {new_left_todo, new_right_todo} = new_left_and_right(left_todo, right_todo, choice)

    new_model = %{model | todos: [new_left_todo, new_right_todo | other_todos]}

    new_model
    |> update_tab_data(fn rating_data ->
      {[left, right], new_other_todos} =
        new_model.todos
        |> Enum.filter(&(&1.status == "pending"))
        |> Enum.shuffle()
        |> Enum.split(2)

      %{
        rating_data
        | top_rated:
            new_model.todos
            |> Enum.filter(&(&1.status == "pending"))
            |> Enum.map(fn todo ->
              %{
                todo
                | rating: %{
                    todo.rating
                    | player: Glicko.new_rating(todo.rating.player, todo.rating.results)
                  }
              }
            end)
            |> Enum.sort_by(& &1.rating.player.rating, :desc)
            |> Enum.take(10),
          left: %{hover: false, todo: left},
          right: %{hover: false, todo: right},
          draw: %{hover: false},
          other_todos: new_other_todos,
          choice: :none
      }
    end)
  end

  defp new_left_and_right(left = %Todo{}, right = %Todo{}, choice) do
    {left_score, right_score} =
      case choice do
        :left -> {:win, :loss}
        :right -> {:loss, :win}
        :draw -> {:draw, :draw}
      end

    {
      %{left | rating: Rating.add_result(left.rating, right.rating, left_score)},
      %{right | rating: Rating.add_result(right.rating, left.rating, right_score)}
    }
  end
end
