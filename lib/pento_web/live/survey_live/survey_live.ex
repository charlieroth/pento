defmodule PentoWeb.SurveyLive do
  alias Pento.Catalog
  use PentoWeb, :live_view
  alias Pento.Survey
  alias Pento.Survey.Demographic
  alias PentoWeb.{DemographicLive, RatingLive}

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_demographic()
      |> assign_products()
    }
  end

  def handle_info({:demographic_created, %Demographic{} = demographic}, socket) do
    {
      :noreply,
      socket
      |> put_flash(:info, "Demographic created successfully")
      |> assign(:demographic, demographic)
    }
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    demographic = Survey.get_demographic_by_user(current_user)
    assign(socket, :demographic, demographic)
  end

  defp assign_products(%{assigns: %{current_user: current_user}} = socket) do
    products = Catalog.list_products_with_user_rating(current_user)
    assign(socket, :products, products)
  end

  def render(assigns) do
    ~H"""
    <section>
      <h2>Survey</h2>
      <%= if @demographic do %>
        <DemographicLive.Show.details demographic={@demographic} />
        <hr />
        <br />
        <RatingLive.Index.product_list current_user={@current_user} products={@products} />
      <% else %>
        <.live_component
          module={DemographicLive.Form}
          id="demographic-form"
          current_user={@current_user}
        />
      <% end %>
    </section>
    """
  end
end
