defmodule DeliriumTremex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :delirium_tremex,
      version: "1.0.0",
      elixir: "~> 1.5",
      package: package(),
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: "https://github.com/VeryBigThings/delirium_tremex",
      docs: [
        main: "DeliriumTremex",
        formatters: ["html", "epub"],
        extras: ["README.md"]
      ],
      deps: deps()
    ]
  end

  defp package do
    [
      description: "Library for standardized Graphql error handling through Absinthe",
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "CHANGELOG.md",
        ".formatter.exs"
      ],
      maintainers: [
        "VeryBigThings"
      ],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://github.com/VeryBigThings/delirium_tremex/CHANGELOG.md",
        GitHub: "https://github.com/VeryBigThings/delirium_tremex"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:gettext, "~> 0.13"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:confex, "~> 3.4"},
      {:ecto, ">= 2.0.0"}
    ]
  end
end
