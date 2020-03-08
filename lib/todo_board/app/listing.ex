defmodule TodoBoard.App.Listing do
  @moduledoc """
  Top-level module for the domain of showing lists of TODOs

  This module acts as the entrypoint for updating the model and generating
  views for the "Listing" tab, where TODOs are listed with various filtering
  applied.
  """

  alias TodoBoard.App.Listing.{Render, Update}

  def update(model, msg) do
    case {model.mode, msg} do
      {:normal, _msg} ->
        Update.Normal.update(model, msg)

      {:panel_selected, _msg} ->
        Update.PanelSelected.update(model, msg)
    end
  end

  defdelegate render(model), to: Render
end
