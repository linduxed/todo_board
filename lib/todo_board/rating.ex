defmodule TodoBoard.Rating do
  @moduledoc """
  Representation of a TODO item rating

  Contains the required data to rank the TODO within a Glicko rating system.
  """

  @enforce_keys [:player, :results]
  defstruct [:player, :results]

  def build do
    %__MODULE__{
      player: %Glicko.Player.V2{},
      results: []
    }
  end

  def build(rating, rating_deviation, rating_volatility)
      when is_number(rating) and
             is_number(rating_deviation) and
             is_number(rating_volatility) do
    %__MODULE__{
      player: %Glicko.Player.V2{
        rating: rating,
        rating_deviation: rating_deviation,
        volatility: rating_volatility
      },
      results: []
    }
  end

  def build(_rating, _rating_deviation, _rating_volatility), do: build()

  def add_result(
        rating = %__MODULE__{},
        opponent = %__MODULE__{},
        score
      )
      when score in [:win, :loss, :draw] do
    new_result = Glicko.Result.new(opponent.player, score)

    %{rating | results: [new_result | rating.results]}
  end
end
