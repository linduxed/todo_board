defmodule TodoBoard.App.Update do
  @moduledoc """
  Top-level `Update` functions, used by all modes

  The update functions in this module should be applicable for almost every
  state that the `Model` could be in.
  """

  def window_resize(model, %{h: height, w: width}) do
    %{model | window: %{height: height, width: width}}
  end
end
