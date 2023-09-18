defmodule PentoWeb.Admin.SurveyResultsLive do
  alias Pento.Catalog
  use PentoWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_products_with_average_ratings()}
  end

  defp assign_products_with_average_ratings(socket) do
    assign(
      socket,
      :products_with_average_ratings,
      Catalog.list_products_with_average_ratings()
    )
  end

  def render(assigns) do
    ~H"""
    <section class="ml-8">
      <h2 class="font-light text-2xl">Survey Results</h2>
      <%= for {product_name, product_average_rating} <- @products_with_average_ratings do %>
        <p>Name: <%= product_name %></p>
        <p>Average Rating: <%= product_average_rating %></p>
      <% end %>
    </section>
    """
  end
end
