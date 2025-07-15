defmodule Plug.Swoosh.MailboxMCP.Tools.ClearMailbox do
  @moduledoc "Delete all emails from the Swoosh local mailbox"
  use Hermes.Server.Component, type: :tool

  schema do
  end

  @impl true
  def execute(_params, frame) do
    count = Swoosh.Adapters.Local.Storage.Memory.all() |> length()
    :ok = Swoosh.Adapters.Local.Storage.Memory.delete_all()

    {:reply, %{message: "Mailbox cleared successfully", deleted_count: count}, frame}
  end
end
