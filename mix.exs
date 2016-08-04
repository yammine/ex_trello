defmodule ExTrello.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_trello,
     version: "0.2.2",
     elixir: "~> 1.3",
     description: "An Elixir package to interface with the Trello API",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :inets, :ssl, :crypto]]
  end

  defp deps do
    [
      {:oauth, github: "tim/erlang-oauth"},
      {:poison, "~> 2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [ maintainers: ["ChrisYammine"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ChrisYammine/ex_trello"} ]
  end
end
