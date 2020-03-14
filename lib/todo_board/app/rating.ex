defmodule TodoBoard.App.Rating do
  @moduledoc """
  FIXME: add documentation

  Top-level module for the domain of showing lists of TODOs

  This module acts as the entrypoint for updating the model and generating
  views for the "Listing" tab, where TODOs are listed with various filtering
  applied.
  """

  alias TodoBoard.App.Base.{Model}
  alias TodoBoard.App.Rating.{Render, Update}

  require Model

  Model.defp__update_tab_data(:rating)

  def update(model = %Model{tab_data: %{rating: :uninitialized}}, _msg) do
    update_tab_data(model, fn _rating_data = :uninitialized ->
      {[left, right], other_todos} =
        model.todos
        |> Enum.filter(&(&1.status == "pending"))
        |> Enum.shuffle()
        |> Enum.split(2)

      %{
        top_rated:
          model.todos
          |> Enum.filter(&(&1.status == "pending"))
          |> Enum.shuffle()
          |> Enum.take(10),
        left: %{hover: false, todo: left},
        right: %{hover: false, todo: right},
        draw: %{hover: false},
        other_todos: other_todos,
        choice: :none
      }
    end)
  end

  def update(model, msg) do
    case {model.mode, msg} do
      {:normal, _msg} ->
        Update.Normal.update(model, msg)
    end
  end

  defdelegate render(model), to: Render
end
