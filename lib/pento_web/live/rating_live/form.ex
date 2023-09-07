defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> clear_form()}
  end

  def handle_event("submit", %{"rating" => rating_params}, socket) do
    rating_params = params_with_user(socket, rating_params)
    {:noreply, save_rating(socket, rating_params)}
  end

  defp save_rating(
         %{assigns: %{product_index: product_index, product: product}} = socket,
         rating_params
       ) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:rating_created, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp params_with_user(socket, rating_params) do
    Map.put(rating_params, "user_id", socket.assigns.current_user.id)
  end

  defp assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  defp clear_form(%{assigns: %{rating: rating}} = socket) do
    assign_form(socket, Survey.change_rating(rating))
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id={@id} phx-target={@myself} phx-submit="submit">
        <.input field={@form[:user_id]} type="hidden" />
        <.input field={@form[:product_id]} type="hidden" />
        <.input
          field={@form[:stars]}
          type="rating"
          label="Rating"
          options={["★ ★ ★ ★ ★": 5, "★ ★ ★ ★": 4, "★ ★ ★": 3, "★ ★": 2, "★": 1]}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
