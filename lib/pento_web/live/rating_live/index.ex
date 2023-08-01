defmodule PentoWeb.RatingLive.Index do
  use Phoenix.Component
  use Phoenix.HTML
  alias PentoWeb.RatingLive

  def rating_complete?(products) do
    Enum.all?(products, fn product ->
      not Enum.empty?(product.ratings)
    end)
  end

  attr :products, :list, required: true
  attr :current_user, :any, required: true

  def product_list(assigns) do
    ~H"""
    <.heading products={@products} />
    <div class="flex flex-col">
      <%= for {product, i} <- Enum.with_index(@products) do %>
        <.product_rating current_user={@current_user} product={product} index={i} />
      <% end %>
    </div>
    """
  end

  attr :products, :list, required: true

  def heading(assigns) do
    ~H"""
    <h2 class="font-medium text-2xl">
      Ratings <%= if rating_complete?(@products), do: raw("&#x2713;") %>
    </h2>
    """
  end

  def product_rating(assigns) do
    ~H"""
    <div class="p-2 mt-2 border border-zinc-800 rounded-sm">
      <h4 class="font-medium text-lg"><%= @product.name %></h4>
      <%= if rating = List.first(@product.ratings) do %>
        <RatingLive.Show.stars rating={rating} product={@product} />
      <% else %>
        <div>
          <h3><%= @product.name %> rating form coming soon!</h3>
        </div>
      <% end %>
    </div>
    """
  end
end
