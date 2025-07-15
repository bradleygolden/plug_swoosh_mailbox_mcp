defmodule Plug.Swoosh.MailboxMCP.Tools.ListEmails do
  @moduledoc "List all emails in the Swoosh local mailbox"
  use Hermes.Server.Component, type: :tool

  schema do
  end

  @impl true
  def execute(_params, frame) do
    emails = Swoosh.Adapters.Local.Storage.Memory.all()

    email_summaries =
      Enum.map(emails, fn email ->
        %{
          id: email.headers["Message-ID"],
          from: format_address(email.from),
          to: format_addresses(email.to),
          subject: email.subject,
          timestamp: email.headers["Date"]
        }
      end)

    {:reply, %{emails: email_summaries, count: length(email_summaries)}, frame}
  end

  defp format_address(nil), do: nil
  defp format_address({name, email}), do: "#{name} <#{email}>"
  defp format_address(email) when is_binary(email), do: email

  defp format_addresses(addresses) when is_list(addresses) do
    Enum.map(addresses, &format_address/1)
  end

  defp format_addresses(address), do: [format_address(address)]
end
