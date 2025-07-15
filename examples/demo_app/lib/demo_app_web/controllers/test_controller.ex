defmodule DemoAppWeb.TestController do
  use DemoAppWeb, :controller
  import Swoosh.Email

  def send_test_email(conn, _params) do
    email = new()
    |> to("user@example.com")
    |> from("admin@example.com")
    |> subject("Test Email #{System.system_time(:second)}")
    |> text_body("This is a test email for MCP server testing")
    |> html_body("<p>This is a <strong>test email</strong> for MCP server testing</p>")

    case DemoApp.Mailer.deliver(email) do
      {:ok, _} ->
        json(conn, %{status: "success", message: "Email sent successfully"})
      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{status: "error", message: "Failed to send email: #{inspect(reason)}"})
    end
  end
end