defmodule Maybex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :maybex,
      version: "1.0.0",
      elixir: "~> 1.5",
      # Docs
      name: "Maybex",
      source_url: "https://github.com/Adzz/maybex",
      docs: [
        main: "Either",
        extras: ["README.md"]
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp description do
    "An implementation of the Maybe monad in elixir"
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      maintainers: ["Adam Lancaster"],
      links: %{"Github" => "https://github.com/adzz/maybex"}
    ]
  end
end
