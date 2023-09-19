defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :live_chart

  alias Pento.Catalog

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_gender_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp assign_age_group_filter(%{assigns: %{age_group_filter: age_group_filter}} = socket) do
    assign(socket, :age_group_filter, age_group_filter)
  end

  defp assign_age_group_filter(socket) do
    assign(socket, :age_group_filter, "all")
  end

  defp assign_gender_filter(%{assigns: %{gender_filter: gender_filter}} = socket) do
    assign(socket, :gender_filter, gender_filter)
  end

  defp assign_gender_filter(socket) do
    assign(socket, :gender_filter, "all")
  end

  defp assign_products_with_average_ratings(
         %{assigns: %{age_group_filter: age_group_filter, gender_filter: gender_filter}} = socket
       ) do
    assign(
      socket,
      :products_with_average_ratings,
      list_products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: gender_filter
      })
    )
  end

  defp list_products_with_average_ratings(filters) do
    case Catalog.list_products_with_average_ratings(filters) do
      [] ->
        Catalog.products_with_zero_ratings()

      products ->
        products
    end
  end

  defp assign_dataset(
         %{assigns: %{products_with_average_ratings: products_with_average_ratings}} = socket
       ) do
    assign(socket, :dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart, title(), subtitle(), x_axis(), y_axis()))
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "Average star ratings per product"
  defp x_axis, do: "Products"
  defp y_axis, do: "Stars"

  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def handle_event("gender_filter", %{"gender_filter" => gender_filter}, socket) do
    {:noreply,
     socket
     |> assign_gender_filter(gender_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp assign_age_group_filter(socket, age_group_filter) do
    assign(socket, :age_group_filter, age_group_filter)
  end

  defp assign_gender_filter(socket, gender_filter) do
    assign(socket, :gender_filter, gender_filter)
  end

  def render(assigns) do
    ~H"""
    <section class="ml-8">
      <h2 class="font-light text-2xl">Survey Results</h2>

      <div id="survey-results-component">
        <div class="conatiner">
          <div>
            <.form
              for={%{}}
              as={:gender_filter}
              phx-change="gender_filter"
              phx-target={@myself}
              id="gender-form"
            >
              <label>By gender:</label>
              <select name="gender_filter" id="gender_filter">
                <%= for gender <- ["all", "female", "male", "other", "prefer not to say"] do %>
                  <option value={gender} selected={@gender_filter == gender}>
                    <%= gender %>
                  </option>
                <% end %>
              </select>
            </.form>
          </div>

          <div>
            <.form
              for={%{}}
              as={:age_group_filter}
              phx-change="age_group_filter"
              phx-target={@myself}
              id="age-group-form"
            >
              <label>By age group:</label>
              <select name="age_group_filter" id="age_group_filter">
                <%= for age_group <- ["all", "18 and under", "18 to 25", "25 to 35", "35 and up"] do %>
                  <option value={age_group} selected={@age_group_filter == age_group}>
                    <%= age_group %>
                  </option>
                <% end %>
              </select>
            </.form>
          </div>
        </div>
        <div id="survey-results-chart">
          <%= @chart_svg %>
        </div>
      </div>
    </section>
    """
  end
end
