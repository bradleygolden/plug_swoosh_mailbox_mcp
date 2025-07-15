defmodule Plug.Swoosh.MailboxMCP.Tools.DeleteEmail do
  @moduledoc "Delete a specific email from the Swoosh local mailbox by ID"
  use Hermes.Server.Component, type: :tool

  schema do
    field :id, :string, required: true
  end

  @impl true
  def execute(%{id: id}, frame) do
    case Swoosh.Adapters.Local.Storage.Memory.get(id) do
      nil ->
        {:error, %Hermes.MCP.Error{code: -32001, message: "Email not found: #{id}"}, frame}

      _email ->
        all_emails = Swoosh.Adapters.Local.Storage.Memory.all()

        filtered_emails =
          Enum.reject(all_emails, fn e ->
            e.headers["Message-ID"] == id
          end)

        Swoosh.Adapters.Local.Storage.Memory.delete_all()

        Enum.each(filtered_emails, fn email ->
          Swoosh.Adapters.Local.Storage.Memory.push(email)
        end)

        {:reply, %{message: "Email deleted successfully", id: id}, frame}
    end
  end
end
