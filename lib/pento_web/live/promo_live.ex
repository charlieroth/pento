defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  @impl true
  def mount(_params, _session, socket) do
    recipient = %Recipient{}
    changeset = Promo.change_recipient(recipient)

    {
      :ok,
      socket
      |> assign(:recipient, recipient)
      |> assign_form(changeset)
    }
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    if socket.assigns.recipient == nil do
      recipient = %Recipient{}
      changeset = Promo.change_recipient(recipient)

      {
        :noreply,
        socket
        |> assign(:recipient, recipient)
        |> assign_form(changeset)
      }
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"recipient" => recipient_params}, socket) do
    changeset =
      socket.assigns.recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    {:ok, _recipient} = Promo.send_promo(recipient_params, %{})

    {
      :noreply,
      socket
      |> assign(:recipient, nil)
      |> put_flash(:info, "Promo Code sent successfully")
      |> push_patch(to: ~p"/promo", replace: true)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Send Your Promo Code to a Friend
      <:subtitle>promo code for 10% off their first game purchase!</:subtitle>
    </.header>

    <div>
      <.simple_form for={@form} id="promo-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:first_name]} type="text" label="First Name" />
        <.input field={@form[:email]} type="email" label="Email" phx-debounce="blur" />
        <:actions>
          <.button phx-disable-with="Sending...">Send Promo Code</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
