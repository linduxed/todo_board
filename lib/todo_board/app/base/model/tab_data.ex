defmodule TodoBoard.App.Base.Model.TabData do
  @moduledoc """
  Defines the state of the application

  The `Model` houses all/most of the information that the application uses. It
  used for rendering the views, and is updated by the `Update` modules for the
  next rendering iteration.
  """

  @enforce_keys [:listing, :rating]
  defstruct [:listing, :rating]
end
