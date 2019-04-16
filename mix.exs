defmodule DeliriumTremex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :delirium_tremex,
      version: "1.0.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
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
      {:ex_doc, "~> 0.16"},
      {:gettext, "~> 0.13"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:confex, "~> 3.4"},
      {:ecto, ">= 2.0.0"}
    ]
  end
end
