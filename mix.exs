defmodule Maybex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :maybex,
      version: "0.0.1",
      elixir: "~> 1.5",
      # Docs
      name: "Maybex",
      source_url: "https://github.com/adzz/maybex",
      docs: [
        main: "Either",
        extras: ["README.md"]
        ],
      start_permanent: Mix.env == :prod,
      deps: deps()
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
end
