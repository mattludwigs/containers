defmodule Containers.Mixfile do
  use Mix.Project

  @version "0.4.0"

  def project do
    [app: :containers,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Functional container like data structures for better runtime safety and polymorphism",
     package: package(),
     deps: deps(),
     docs: docs()]
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
    [{:ex_doc, "~> 0.14", only: :dev, runtime: false},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false}]
  end

  defp package do
    [
      maintainers: ["Matt Ludwigs"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/mattludwigs/containers"},
    ]
  end

  defp docs do
    [ source_ref: @version,
      source_url: "https://github.com/mattludwigs/containers",
      extras: [
        "README.md",
        "CHANGELOG.md"
    ]]
  end
end
