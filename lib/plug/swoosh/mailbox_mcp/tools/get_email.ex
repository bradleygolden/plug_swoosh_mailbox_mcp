defmodule Plug.Swoosh.MailboxMCP.Tools.GetEmail do
  @moduledoc "Get a specific email from the Swoosh local mailbox by ID"
  use Hermes.Server.Component, type: :tool

  schema do
    field :id, :string, required: true
  end

  @impl true
  def execute(%{id: id}, frame) do
    case Swoosh.Adapters.Local.Storage.Memory.get(id) do
      nil ->
        {:error, %Hermes.MCP.Error{code: -32001, message: "Email not found: #{id}"}, frame}

      email ->
        {:reply,
         %{
           id: email.headers["Message-ID"],
           from: format_address(email.from),
           to: format_addresses(email.to),
           cc: format_addresses(email.cc),
           bcc: format_addresses(email.bcc),
           subject: email.subject,
           text_body: email.text_body,
           html_body: email.html_body,
           headers: email.headers,
           attachments: format_attachments(email.attachments)
         }, frame}
    end
  end

  defp format_address(nil), do: nil
  defp format_address({name, email}), do: "#{name} <#{email}>"
  defp format_address(email) when is_binary(email), do: email

  defp format_addresses(nil), do: []

  defp format_addresses(addresses) when is_list(addresses) do
    Enum.map(addresses, &format_address/1)
  end

  defp format_addresses(address), do: [format_address(address)]

  defp format_attachments(nil), do: []

  defp format_attachments(attachments) when is_list(attachments) do
    Enum.map(attachments, fn attachment ->
      %{
        filename: attachment.filename,
        content_type: attachment.content_type,
        size: byte_size(attachment.data)
      }
    end)
  end
end
