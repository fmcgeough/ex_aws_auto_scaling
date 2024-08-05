defmodule ExAwsAutoScaling.Mixfile do
  use Mix.Project

  @source_url "https://github.com/fmcgeough/ex_aws_auto_scaling"
  @version "0.2.1"

  def project do
    [
      app: :ex_aws_auto_scaling,
      version: @version,
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      name: "ex_aws_auto_scaling",
      description: "EC2 Auto Scaling API",
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs()
    ]
  end

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
      {:sweet_xml, "~> 0.6", optional: true},
      {:hackney, "1.6.3 or 1.6.5 or 1.7.1 or 1.8.6 or ~> 1.9", only: [:dev, :test]},
      {:poison, ">= 1.2.0", optional: true},
      {:ex_doc, "~> 0.34.2", only: [:dev, :test]},
      {:ex_aws, "~> 2.0"},
      {:dialyxir, "~> 1.4", only: [:dev]}
    ]
  end

  defp docs do
    [
      name: "ExAutoScaling",
      canonical: "http://hexdocs.pm/ex_aws_auto_scaling",
      source_url: @source_url,
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      maintainers: ["Frank McGeough"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
