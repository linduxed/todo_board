defmodule TodoBoard.App.Update do
  def window_resize(model, %{h: height, w: width}) do
    %{model | window: %{height: height, width: width}}
  end
end
