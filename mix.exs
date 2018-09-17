defmodule ScenicBattery.MixProject do
  use Mix.Project

  @scenic_version "0.7.0"
  @github "https://github.com/ruffin/scenic_battery"

  def project do
    [
      app: :scenic_battery,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "Scenic.Battery.Components"
      ],
      description: description(),
      package: [
        name: :scenic_battery,
        contributors: ["Jonathan Ruffin"],
        maintainers: ["Jonathan Ruffin"],
        licenses: ["Apache 2"],
        links: %{github: @github}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> #{@scenic_version}"},
      {:ex_doc, ">=0.0.0", only: [:dev, :docs]},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description() do
    """
    Scenic.Battery - A battery monitor for Scenic
    """
  end
end
