defmodule TodoBoard.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo_board,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
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
      {:ex_doc, "~> 0.21.1", only: :dev, runtime: false},
      {:ratatouille, "~> 0.5.0"}
    ]
  end
end
