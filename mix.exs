defmodule TodoBoard.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo_board,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {TodoBoard, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ratatouille, "~> 0.5.0"}
    ]
  end
end
