defmodule Containers.Mixfile do
  use Mix.Project

  @version "0.7.1"

  def project do
    [
      app: :containers,
      version: @version,
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description:
        "Functional container like data structures for better runtime safety and polymorphism",
      package: package(),
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      dialyzer: dialyzer(),
      preferred_cli_env: [docs: :docs, "hex.publish": :docs]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.22", only: :docs, runtime: false}
    ]
  end

  defp aliases do
    [{:dev, "test.watch"}]
  end

  defp package do
    [
      maintainers: ["Matt Ludwigs"],
      licenses: ["Apache-2.0"],
      links: %{github: "https://github.com/mattludwigs/containers"}
    ]
  end

  defp docs do
    [
      source_ref: @version,
      source_url: "https://github.com/mattludwigs/containers",
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: "dialyzer.ignore_warnings",
      flags: [:unmatched_returns, :error_handling, :race_conditions]
    ]
  end
end
