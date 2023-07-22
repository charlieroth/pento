defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Catalog
  alias Pento.Catalog.ProductSearch

  def mount(_parmas, _session, socket) do
    product_search = %ProductSearch{}
    changeset = Catalog.change_product_search(product_search)

    {
      :ok,
      socket
      |> assign(search_results: nil, product_search: product_search)
      |> assign_form(changeset)
    }
  end

  def handle_event("search-change", %{"product_search" => product_search_params}, socket) do
    changeset =
      socket.assigns.product_search
      |> Catalog.change_product_search(product_search_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("search", %{"product_search" => product_search_params}, socket) do
    search_results =
      Catalog.search_products(%{
        name: product_search_params["name"],
        description: product_search_params["description"]
      })

    {:noreply, assign(socket, :search_results, search_results)}
  end

  defp assign_form(socket, changeset) do
    socket |> assign(:form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <.header>
      Product Search
      <:subtitle>Search for products by name or description</:subtitle>
    </.header>

    <.simple_form for={@form} id="search-form" phx-change="search-change" phx-submit="search">
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:description]} type="text" label="Description" />
      <:actions>
        <.button phx-disable-with="Searching...">Search</.button>
      </:actions>
    </.simple_form>

    <br />

    <%= if @search_results == nil do %>
      <p>Please enter search criteria</p>
    <% end %>

    <%= if @search_results != nil and @search_results == [] do %>
      <p>No results</p>
    <% end %>

    <%= if @search_results != nil and not Enum.empty?(@search_results) do %>
      <%= for product <- @search_results do %>
        <.list>
          <:item title="Name"><%= product.name %></:item>
          <:item title="Description"><%= product.description %></:item>
        </.list>
      <% end %>
    <% end %>
    """
  end
end
