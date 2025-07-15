defmodule Plug.Swoosh.MailboxMCP.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_swoosh_mailbox_mcp,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Plug.Swoosh.MailboxMCP.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hermes_mcp, "~> 0.12.1"},
      {:swoosh, "~> 1.19"},
      {:plug, "~> 1.14"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A Plug that exposes Swoosh local mailbox data via the Model Context Protocol (MCP), enabling AI agents to access email data programmatically."
  end

  defp package do
    [
      name: "plug_swoosh_mailbox_mcp",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bradleygolden/plug_swoosh_mailbox_mcp"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
