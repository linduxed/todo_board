defmodule TodoBoard.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo_board,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
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
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ex_machina, "~> 2.4", only: :test},
      {:glicko, github: "linduxed/elixir-glicko", branch: "develop"},
      {:logger_file_backend, "~> 0.0.11"},
      {:ratatouille, "~> 0.5.0"},
      {:stream_data, "~> 0.5.0"},
      {:taskwarrior, "~> 0.4"}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
