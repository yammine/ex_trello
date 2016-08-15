defmodule ExTrello.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_trello,
     version: "0.4.2",
     elixir: "~> 1.3",
     description: "An Elixir package to interface with the Trello API",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.html": :test],
     deps: deps(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :inets, :ssl, :crypto, :httpotion]]
  end

  defp deps do
    [
      {:oauther, "~> 1.0.1"},
      {:poison, "~> 2.0"},
      {:httpotion, "~> 3.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:exvcr, "~> 0.7", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    [ maintainers: ["ChrisYammine"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ChrisYammine/ex_trello"} ]
  end
end
