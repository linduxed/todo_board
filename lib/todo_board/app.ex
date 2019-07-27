defmodule TodoBoard.App do
  @moduledoc """
  The Ratatouille application
  """

  @behaviour Ratatouille.App

  import Ratatouille.View

  @impl true
  def init(_context) do
    :model
  end

  @impl true
  def update(model, _msg) do
    model
  end

  @impl true
  def render(_model) do
    view do
      label(content: "TodoBoard")
    end
  end
end
